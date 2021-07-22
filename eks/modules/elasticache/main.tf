# Notes:
# Provides an ElastiCache Cluster resource, which manages either a Memcached cluster, a single-node Redis instance,
# or a [read replica in a Redis (Cluster Mode Enabled) replication group].
# For working with Redis (Cluster Mode Enabled) replication groups, see the aws_elasticache_replication_group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group


resource "aws_elasticache_cluster" "default" {
  cluster_id           = "${var.name}"
  engine               = "${var.type}"
  node_type            = "${var.node_type}"
  num_cache_nodes      = "${var.node_count}"
  parameter_group_name = "${var.group}"
  port                 = "${var.port}"
  subnet_group_name    = "${var.subnet_group}"
  security_group_ids   = ["${var.security_group}"]
  az_mode              = "${var.az_mode}"
  availability_zone    = "${var.zone}"
  availability_zones   = "${var.zones}"
  parameter_group_name = "${aws_elasticache_parameter_group.default.name}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_elasticache_parameter_group" "default" {
  name        = "${var.name}"
  description = "Elasticache parameter group"
  family      = "${var.cluster_family}"
  parameter   = ["${var.cluster_parameters}"]
}
