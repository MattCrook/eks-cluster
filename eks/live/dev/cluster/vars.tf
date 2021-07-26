variable "region" {
  description = "Region that the cluster resides"
  type        = string
  default     = "us-east-1"
}

#################
# Security group
#################

variable "create_security_group" {
  description = "Define as true if you want to create a security group. False will not."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the Security Group"
  type        = string
  default     = "EKSClusterSecurityGroup"
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {
    Name = "EKSDefaultSecurityGroup"
    env = "dev"
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
