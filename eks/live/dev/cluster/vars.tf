variable "ingress_security_group_name" {
  description = "Name of security group"
  type        = string
  default     = "AllowInbound"
}

variable "allow_all_outbound" {
  description = "Name of security group"
  type        = string
  default     = "AllowOutbound"
}

variable "allow_ssh" {
  description = "Name of security group"
  type        = string
  default     = "AllowSSH"
}
