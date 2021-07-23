provider "aws" {
  region  = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}


module "cluster" {
    source = "../../../modules/cluster"

    cluster_name           = "EKSCluster"
    region                 = "${var.region}"
    ami_id                 = "ami-0eeeef929db40543c"
    # vpc_id                 = "${module.vpc.vpc_id}"
    # private_subnets        = "${module.vpc.private_subnets}"
    vpc_id                 = "${data.aws_vpc.default.id}"
    # private_subnets        = tolist(data.aws_subnet_ids.default.ids)
    private_subnets        =   ["subnet-1da7eb3c", "subnet-4a337115", "subnet-531a5b35"]
    instance_type          = "t2.medium"
    log_retention_days     = 5
    instance_count         = 2
    # worker_security_groups = [aws_security_group.default[count.index].id]
    # master_security_groups = [aws_security_group.default[count.index].id]
    name                   = "${var.name}"
    create_security_group  = "${var.create_security_group}"
    description            = "${var.description}"
    tags                   = {for k, v in var.tags : k => v}
}


resource "aws_security_group_rule" "allow_all_inbound" {
    security_group_id = tolist(module.cluster.default_security_group_id)[0]
    type              = "ingress"
    description       = "http"
    from_port         = 80
    to_port           = 80
    cidr_blocks       = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["${var.ingress_ipv6_cidr_blocks}"]
    protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_all_outbound" {
    security_group_id = tolist(module.cluster.default_security_group_id)[0]
    type              = "egress"
    from_port         = 0
    to_port           = 0
    cidr_blocks       = ["0.0.0.0/0"]
    # cidr_blocks      = ["${var.egress_cidr_blocks}"]
    # ipv6_cidr_blocks = ["${var.egress_ipv6_cidr_blocks}"]
    protocol          = "-1"
}

resource "aws_security_group_rule" "allow_ssh" {
    security_group_id = tolist(module.cluster.default_security_group_id)[0]
    type              = "ingress"
    description       = "ssh"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
}
