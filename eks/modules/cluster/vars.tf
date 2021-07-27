variable account_id { default = "067352809764" }
variable region {}
variable log_retention_days { default = 7 }
variable ami_name { default = "amazon-eks-node-1.11-v*"}
variable instance_type { default = "t2.medium" }
variable prefix { default = "eks-"}
variable cluster_name { default = "EKSCluster"}
variable instance_count { default = 2 }
variable master_role_name { default = "EKSMaster"}
variable worker_role_name { default = "EKSWorker"}
variable maintenance_window { default = "cron(0 0 9 ? * SUN *)"}
variable tags { description = "Tags of the Security Group" }
variable description { description = "Description of security group" }


variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
}

variable "create_security_group" {
  description = "Define as true if you want to create a security group. False will not."
  type        = bool
}

variable "worker_security_groups" {
  description = "A list of associated security group ID's"
  type        = list(string)
  default     = []
}

variable "master_security_groups" {
  description = "A list of associated security group ID's"
  type        = list(string)
  default     = []
}

// variable "private_subnets" {
//   description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside"
//   type        = list(string)
// }

# VPC ID for the security groups. Variable is filled in in the module, by gettig the value of the output of the module for vpc.
// variable "vpc_id" {
//   description = "ID of the VPC where to create security group"
// }

variable "name" {
  description = "Name of the Security Group"
  type        = string
}

variable "ami_id" {
  description = "ID of the ami to use as the image for the VM of the node. Can be found on the Amazon Marketplace"
  type        = string
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = "AL2_x86_64"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = string
  default     = "50"
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the Node group (or Node Pool)"
  type        = string
}

#######################################
# Scaling Config for aws_eks_node_group
#######################################
variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

// variable "source_security_group_id" {
//   description = "Security group id to allow access to/from, depending on the type"
//   type        = string
// }
