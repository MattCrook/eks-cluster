resource "aws_eks_cluster" "cluster" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.cluster.arn}"
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    security_group_ids = [aws_security_group.default[0].id]
    subnet_ids         = "${var.private_subnets}"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.kubernetes
  ]
}

resource "aws_cloudwatch_log_group" "kubernetes" {
  name              = "kubernetes"
  retention_in_days = "${var.log_retention_days}"
}


# Manages an EKS Node Group, which can provision and optionally update an Auto Scaling Group of Kubernetes worker nodes compatible with EKS.
# Amazon EKS managed node groups automate the provisioning and lifecycle management of nodes (Amazon EC2 instances) for Amazon EKS Kubernetes clusters.
# With Amazon EKS managed node groups, you don’t need to separately provision or register the Amazon EC2 instances that provide compute capacity to run your Kubernetes applications.
# You can create, automatically update, or terminate nodes for your cluster with a single operation.
resource "aws_eks_node_group" "node_pool" {
  cluster_name    = "${aws_eks_cluster.clsuter.name}"
  node_group_name = "${var.node_group_name}"
  node_role_arn   = aws_iam_role.example.arn
  subnet_ids      = aws_subnet.example[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_launch_configuration" "node" {
  iam_instance_profile = "${aws_iam_instance_profile.node.name}"
  image_id              = "${var.ami_id}"
  # image_id             = "${data.aws_ami.eks-worker.id}"
  instance_type        = "${var.instance_type}"
  name_prefix          = "${var.prefix}${var.cluster_name}"
  security_groups      = [aws_security_group.default[0].id]
  user_data_base64     = "${base64encode(local.node-userdata)}"

  root_block_device {
    volume_size = "50"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Separately provisioning or registering the Amazon EC2 instances that provide compute capacity to run the Kubernetes application.
# This will show up in the EC2 console, but not in the EKS console, as these are not node pools or nodes. Just instances to provide compute resources that are tied to the cluster.
# The name of the instances will be easy to recignize (eks-EKSCluster) making it clear it is tied to the cluster.
resource "aws_autoscaling_group" "node" {
  desired_capacity     = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.node.id}"
  max_size             = "${var.instance_count * 2}"
  min_size             = 2
  name                 = "${var.prefix}${var.cluster_name}"
  vpc_zone_identifier  = "${var.private_subnets}"

  tag {
    key                 = "Name"
    value               = "${var.prefix}${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [ desired_capacity ]
  }
}

resource "aws_security_group" "default" {
    count       = var.create_security_group ? 1 : 0
    name        = "${var.name}"
    description = "${var.description}"
    vpc_id      = "${var.vpc_id}"
    tags        = "${var.tags}"
}

    # vpc_id      = "${var.vpc_id}"
    # tags        = "${merge(var.tags, tomap("Name", format("%s", var.name)))}"
    # tags        = "${tomap(for k, v in var.tags : k => v.id)}"
