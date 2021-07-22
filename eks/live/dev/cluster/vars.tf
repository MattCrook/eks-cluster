variable "region" {
  description = "Region that the cluster resides"
  type        = string
  default     = "us-east-1"
}

#################
# Security group
#################

variable "create" {
  description = "Whether to create security group and all rules"
  default     = true
}

variable "name" {
  description = "Name of the Security Group"
  type        = string
  default     = "DefaultSecurityGroup"
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
}

variable "description" {
  description = "Description of security group"
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {
    Name = DefaultSecurityGroup
    env = dev
  }
}

##########
# Ingress
##########

variable "ingress_security_group_name" {
  description = "Name of security group"
  type        = string
  default     = "AllowInbound"
}

#########
# Egress
#########

variable "allow_all_outbound" {
  description = "Name of security group"
  type        = string
  default     = "AllowOutbound"
}

#########
# SSH
#########

variable "allow_ssh" {
  description = "Name of security group"
  type        = string
  default     = "AllowSSH"
}
