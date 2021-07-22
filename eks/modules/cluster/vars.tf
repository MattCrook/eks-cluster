variable account_id {}
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

variable "private_subnets" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside"
  type        = list(string)
  default     = []
}

# VPC ID for the security groups. Variable is filled in in the module, by gettig the value of the output of the module for vpc.
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
}
