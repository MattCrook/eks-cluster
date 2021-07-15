output "name" {
  value       = "${join("", aws_rds_cluster.default.*.database_name)}"
  description = "Database name"
}

output "user" {
  value       = "${join("", aws_rds_cluster.default.*.master_username)}"
  description = "Username for the master DB user"
}

output "password" {
  value       = "${join("", aws_rds_cluster.default.*.master_password)}"
  description = "Password for the master DB user"
}

output "cluster_name" {
  value       = "${join("", aws_rds_cluster.default.*.cluster_identifier)}"
  description = "Cluster Identifier"
}

output "endpoint" {
  value       = "${join("", aws_rds_cluster.default.*.endpoint)}"
  description = "Cluster endpoint"
}

output "read_endpoint" {
  value       = "${join("", aws_rds_cluster.default.*.reader_endpoint)}"
  description = "Cluster reader endpoint"
}
