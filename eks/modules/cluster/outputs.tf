output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "region" {
  value = var.region
}

output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.node_pool.arn
}

output "resources" {
  description = "List of objects containing information about underlying resources"
  value       = "${aws_eks_node_group.node_pool.resources}"
}

output "autoscaling_groups" {
  description = "List of objects containing information about AutoScaling Groups"
  value       = "${aws_eks_node_group.node_pool.resources[*].autoscaling_groups}"
}

output "autoscaling_group_names" {
  description = "Name of the AutoScaling Group"
  value       = "${aws_eks_node_group.node_pool.resources[*].autoscaling_groups[*].name}"
}

output "remote_access_security_group_id" {
  description = "Identifier of the remote access EC2 Security Group"
  value       = aws_eks_node_group.node_pool.resources.*.remote_access_security_group_id
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

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication"
  value       = "${aws_eks_cluster.cluster.vpc_config[*].cluster_security_group_id}"
}


###################################
# Default VPC for testing purposes
##################################

output "vpc_id" {
  value = aws_vpc.default.id
}


// output "subnet_cidr_blocks" {
//   value = [for s in data.aws_subnet.default : s.cidr_block]
// }

// output "aws_subnet_ids" {
//   value = data.aws_subnet_ids.default.ids
// }

output "subnet_cidr_blocks" {
  value = [for s in aws_subnet.default : s.cidr_block]
}

// data "aws_subnet" "default" {
//   for_each = { for subnet in aws_subnet.default : subnet.id => subnet }
//   id = each.key
//   for_each = aws_subnet.default[*].id
//   id       = each.value
// }

// data "aws_subnet_ids" "default" {
//     vpc_id = aws_vpc.default.id
// }

output "aws_subnet_ids" {
  description = "List of the subnet ID's in the created named default VPC"
  value       = [for subnet in aws_subnet.default : subnet.id]
}
