output "configuration_endpoint" {
  value = "${aws_elasticache_cluster.default.configuration_endpoint}"
}

output "endpoint" {
  value = "${aws_elasticache_cluster.default.cluster_address}"
}
