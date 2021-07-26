resource "aws_security_group" "default" {
  count       = var.create_security_group ? 1 : 0

  name        = "${var.name}"
  description = "${var.description}"
  vpc_id      = "${aws_vpc.default.id}"
  tags        = "${var.tags}"
}

# vpc_id      = "${var.vpc_id}"
# tags        = "${merge(var.tags, tomap("Name", format("%s", var.name)))}"
# tags        = "${tomap(for k, v in var.tags : k => v.id)}"


resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "egress"
}


resource "aws_security_group_rule" "ingress_workers" {
  description              = "Allow the cluster to receive communication from the worker nodes"
  from_port                = 0
  # to_port                  = 65535
  to_port                  = 0
  protocol                 = "-1"
  # source_security_group_id = "${var.source_security_group_id}"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

// resource "aws_security_group_rule" "ingress_security_groups" {
//   description              = "Allow inbound traffic from existing Security Groups"
//   from_port                = 0
//   # to_port                  = 65535
//   to_port                  = 0
//   protocol                 = "-1"
//   cidr_blocks              = ["0.0.0.0/0"]
//   # source_security_group_id = "${var.source_security_group_id}"
//   security_group_id        = join("", aws_security_group.default.*.id)
//   type                     = "ingress"
// }

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = 0
  # to_port           = 65535
  to_port           = 0
  protocol          = "-1"
  # cidr_blocks       = var.allowed_cidr_blocks
  cidr_blocks       = [for s in aws_subnet.default : s.cidr_block]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_ssh" {
  description       = "Allow SSH onto Nodes"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}
