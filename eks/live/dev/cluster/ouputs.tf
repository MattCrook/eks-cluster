output "endpoint" {
  value = module.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.cluster.kubeconfig-certificate-authority-data
}

output "default_security_group_id" {
  description = "The ID of the security group"
  value       = "${module.cluster.default_security_group_id}"
}

output "default_security_group_vpc_id" {
  description = "The VPC ID"
  value       = "${module.cluster.default_security_group_vpc_id}"
}

output "default_security_group_owner_id" {
  description = "The owner ID"
  value       = "${module.cluster.default_security_group_owner_id}"
}

output "default_security_group_name" {
  description = "The name of the security group"
  value       = "${module.cluster.default_security_group_name}"
}

output "default_security_group_description" {
  description = "The description of the security group"
  value       = "${module.cluster.default_security_group_description}"
}
