terraform {
  required_version = ">= 0.12"
}

resource "aws_eks_cluster" "cluster" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.eks_assume.arn}"
  # enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    security_group_ids = ["${var.master_security_groups}"]
    subnet_ids = ["${var.private_subnets}"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.cluster
  ]
}

resource "aws_cloudwatch_log_group" "kubernetes" {
  name = "kubernetes"
  retention_in_days = "${var.log_retention_days}"
}


resource "aws_launch_configuration" "node" {
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.prefix}${var.cluster_name}"
  security_groups             = ["${var.worker_security_groups}"]
  user_data_base64            = "${base64encode(local.node-userdata)}"

  root_block_device {
    volume_size = "50"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "node" {
  desired_capacity     = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.node.id}"
  max_size             = "${var.instance_count * 2}"
  min_size             = 2
  name                 = "${var.prefix}${var.cluster_name}"
  vpc_zone_identifier  = ["${var.private_subnets}"]

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
    ignore_changes = [ "desired_capacity" ]
  }
}

locals {
  http_port     = 80
  any_port      = 0
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  http_protocol = "http"
  all_ips       = ["0.0.0.0/0"]
}

resource "aws_security_group" "allow_all_inbound" {
    name        = "${var.ingress_security_group_name}"
    vpc_id      = "${var.vpc_id}"

    ingress {
        description = local.http_protocol
        from_port   = local.http_port
        to_port     = local.http_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }

    tags = {
        Name = "allow_inbound"
    }
}

resource "aws_security_group" "allow_all_outbound" {
    name        = "${var.egress_security_group_name}"
    vpc_id      = "${var.vpc_id}"

    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = local.all_ips
    }

    tags = {
        Name = "allow_outbound"
    }
}

resource "aws_security_group" "allow_ssh" {
    name        = "${var.ssh_security_group_name}"
    vpc_id      = "${var.vpc_id}"

    ingress {
        description = "ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
    }
}
