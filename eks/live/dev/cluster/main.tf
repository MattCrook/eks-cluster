provider "aws" {
  region  = "${var.region}"
}

module "cluster" {
    cluster_name           = "EKSCluster"
    vpc_id                 = "${module.vpc.vpc_id}"
    private_subnets        = "${module.vpc.private_subnets}"
    instance_type          = "t2.medium"
    log_retention_days     = 5
    instance_count         = 2
    worker_security_groups = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
    master_security_groups = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "default" {
    count       = "${var.create}"
    name        = "${var.name}"
    description = "${var.description}"
    vpc_id      = "${var.vpc_id}"
    tags        = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_security_group_rule" "allow_all_inbound" {
    security_group_id = "${aws_security_group.default.id}"
    vpc_id            = "${var.vpc_id}"
    type              = "ingress"
    description       = "http"
    from_port         = 80
    to_port           = 80
    cidr_blocks       = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["${var.ingress_ipv6_cidr_blocks}"]
    protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_all_outbound" {
    security_group_id = "${aws_security_group.default.id}"
    vpc_id            = "${var.vpc_id}"
    type              = "egress"
    from_port         = 0
    to_port           = 0
    cidr_blocks       = ["0.0.0.0/0"]
    # cidr_blocks      = ["${var.egress_cidr_blocks}"]
    # ipv6_cidr_blocks = ["${var.egress_ipv6_cidr_blocks}"]
    protocol          = "-1"
}

resource "aws_security_group_rule" "allow_ssh" {
    security_group_id = "${aws_security_group.default.id}"
    vpc_id            = "${var.vpc_id}"
    type              = "ingress"
    description       = "SSH"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
}
