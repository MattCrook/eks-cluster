output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "default_security_group_id" {
  description = "The ID of the security group"
  value       = "${aws_security_group.default.*.id}"
}

output "default_security_group_vpc_id" {
  description = "The VPC ID"
  value       = "${aws_security_group.default.*.vpc_id}"
}

output "default_security_group_owner_id" {
  description = "The owner ID"
  value       = "${aws_security_group.default.*.owner_id}"
}

output "default_security_group_name" {
  description = "The name of the security group"
  value       = "${aws_security_group.default.*.name}"
}

output "default_security_group_description" {
  description = "The description of the security group"
  value       = "${aws_security_group.default.*.description}"
}
