// resource "aws_kms_key" "cluster" {
//   count                   = local.enabled && var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
//   description             = "EKS Cluster ${module.label.id} Encryption Config KMS Key"
//   enable_key_rotation     = var.cluster_encryption_config_kms_key_enable_key_rotation
//   deletion_window_in_days = var.cluster_encryption_config_kms_key_deletion_window_in_days
//   policy                  = var.cluster_encryption_config_kms_key_policy
//   tags                    = module.label.tags
// }

// resource "aws_kms_alias" "cluster" {
//   count         = local.enabled && var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
//   name          = format("alias/%v", module.label.id)
//   target_key_id = join("", aws_kms_key.cluster.*.key_id)
// }


resource "aws_eks_cluster" "cluster" {
  name                      = "${var.cluster_name}"
  role_arn                  = "${aws_iam_role.cluster.arn}"
  enabled_cluster_log_types = ["api", "audit"]
  version                   = "1.21"

  vpc_config {
    security_group_ids      = "${aws_security_group.default.*.id}"
    # security_group_ids      = ["${var.master_security_groups}"]
    # subnet_ids              = "${var.private_subnets}"
    subnet_ids              = [for subnet in aws_subnet.default : subnet.id]
    endpoint_private_access = "${var.endpoint_private_access}"
    endpoint_public_access  = "${var.endpoint_public_access}"
    # public_access_cidrs     = var.public_access_cidrs
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.kubernetes,
    aws_security_group.default
  ]
}

#################################################
# SSH Key for worker nodes/ Node Group
# Key will be saved locally for now, and should be used when tyring to SSH onto a Node.
# chmod 400 webserver_key.pem

# ssh -i "webserver_key.pem" ec2-user@ec2-13-36-235-21.eu-west-3.compute.amazonaws.com

#################################################
resource "tls_private_key" "node_group_private_key" {
   algorithm = "RSA"
   rsa_bits  = 4096
}

resource "local_file" "private_key" {
   content         = tls_private_key.node_group_private_key.private_key_pem
   filename        = "node_group_key.pem"
   file_permission = 0400
}

resource "aws_key_pair" "node_group_key" {
   key_name   = "NodegGroupSSHKey"
   public_key = tls_private_key.node_group_private_key.public_key_openssh
}



###########################################################################
# AWS EKS Node Group
# Manages an EKS Node Group, which can provision and optionally update an Auto Scaling Group of Kubernetes worker nodes compatible with EKS.
# Amazon EKS managed node groups automate the provisioning and lifecycle management of nodes (Amazon EC2 instances) for Amazon EKS Kubernetes clusters.
# With Amazon EKS managed node groups, you don’t need to separately provision or register the Amazon EC2 instances that provide compute capacity to run your Kubernetes applications.
# You can create, automatically update, or terminate nodes for your cluster with a single operation.
# All node groups are created with the latest AMI release version for the respective minor Kubernetes version of the cluster,
# UNLESS you deploy a custom AMI using a launch template. (Use aws_launch_template to do this).
# An Amazon EKS managed node group is an Amazon EC2 Auto Scaling group and associated Amazon EC2 instances that are managed by AWS for an Amazon EKS cluster.
# Right now, this is a single AZ node pool (cluster). Nodes will be put into the subnets defined by CIDR blocks. Can create a multi AZ cluster, example:
# https://github.com/umotif-public/terraform-aws-eks-node-group/blob/master/examples/multiaz-node-group/main.tf
###########################################################################

resource "aws_eks_node_group" "node_pool" {
  cluster_name    = "${aws_eks_cluster.cluster.name}"
  node_group_name = "${var.node_group_name}"
  node_role_arn   = "${aws_iam_role.node.arn}"
  # subnet_ids      = "${var.subnet_ids}"
  # subnet_ids      = [for subnet in aws_subnet.default : subnet.id]
  subnet_ids      = aws_subnet.default[*].id
  ami_type        = "${var.ami_type}"
  disk_size       = "${var.disk_size}"
  instance_types  = "${var.instance_types}"
  version         = "1.21"

  // launch_template {
  //   id      = aws_launch_template.cluster.id
  //   version = aws_launch_template.cluster.latest_version
  // }

  scaling_config {
    desired_size = "${var.desired_size}"
    max_size     = "${var.max_size}"
    min_size     = "${var.min_size}"
  }

  remote_access {
    # source_security_group_ids = [var.source_security_group_id, aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id, aws_security_group.default[0].id]
    ec2_ssh_key               = "${aws_key_pair.node_group_key.key_name}"

    source_security_group_ids = "${aws_security_group.default.*.id}"
    # source_security_group_ids = aws_eks_node_group.node_pool.resources.*.remote_access_security_group_id
  }

  tags = {
    Environment = "dev"
    # "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  # Kubernetes labels
  labels = {
    lifecycle = "OnDemand"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

# Using data source to get info such as SHA1 fingerprint or serial number, about the TLS certificates that protect an HTTPS website.
# Getting this to use as URL for aws_iam_openid_connect_provider to associate cluster to the OpenIDConnect provider.
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Enable OIDC for Cluster
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Provides a CloudWatch Log Group resource
resource "aws_cloudwatch_log_group" "kubernetes" {
  name              = "kubernetes"
  retention_in_days = "${var.log_retention_days}"
}
