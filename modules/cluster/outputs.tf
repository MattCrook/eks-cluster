output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}

output "default_security_group_id" {
  description = "The ID of the security group"
  value       = "${element(concat(aws_security_group.default.*.id, list("")), 0)}"
}

output "default_security_group_vpc_id" {
  description = "The VPC ID"
  value       = "${element(concat(aws_security_group.default.*.vpc_id, list("")), 0)}"
}

output "default_security_group_owner_id" {
  description = "The owner ID"
  value       = "${element(concat(aws_security_group.default.*.owner_id, list("")), 0)}"
}

output "default_security_group_name" {
  description = "The name of the security group"
  value       = "${element(concat(aws_security_group.default.*.name, list("")), 0)}"
}

output "default_security_group_description" {
  description = "The description of the security group"
  value       = "${element(concat(aws_security_group.default.*.description, list("")), 0)}"
}
