output "endpoint" {
  value = module.cluster.endpoint
}

output "region" {
  value = module.cluster.region
}

output "cluster_name" {
  value = module.cluster.cluster_name
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = "${module.cluster.node_group_arn}"
}

output "resources" {
  description = "List of objects containing information about underlying resources"
  value       = "${module.cluster.resources}"
}

output "autoscaling_groups" {
  description = "List of objects containing information about AutoScaling Groups"
  value       = "${module.cluster.autoscaling_groups}"
}

output "autoscaling_group_names" {
  description = "Name of the AutoScaling Group"
  value       = "${module.cluster.autoscaling_group_names}"
}

output "remote_access_security_group_id" {
  description = "Identifier of the remote access EC2 Security Group"
  value       = "${module.cluster.remote_access_security_group_id}"
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

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication"
  value       = "${module.cluster.cluster_security_group_id}"
}

// output "source_security_group_id" {
//   description = "Security group id to allow access to/from, depending on the type"
//   value       = "${aws_security_group.worker.id}"
// }


// output "worker_security_group_id" {
//   description = "The ID of the security group"
//   value       = "${aws_security_group.worker.id}"
// }

// output "worker_security_group_vpc_id" {
//   description = "The VPC ID"
//   value       = "${aws_security_group.worker.vpc_id}"
// }

// output "worker_security_group_owner_id" {
//   description = "The owner ID"
//   value       = "${aws_security_group.worker.owner_id}"
// }

// output "worker_security_group_name" {
//   description = "The name of the security group"
//   value       = "${aws_security_group.worker.name}"
// }

// output "worker_security_group_description" {
//   description = "The description of the security group"
//   value       = "${aws_security_group.worker.description}"
// }


###################################
# Default VPC for testing purposes
##################################
// output "subnet_cidr_blocks" {
//   value = [for s in data.aws_subnet.default : s.cidr_block]
// }

// output "aws_subnet_ids" {
//   value = data.aws_subnet_ids.default.ids
// }

output "subnet_cidr_blocks" {
  value = module.cluster.subnet_cidr_blocks
}

output "aws_subnet_ids" {
  value = module.cluster.aws_subnet_ids
}
