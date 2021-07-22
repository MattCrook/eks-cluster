variable name {}
variable type {}
variable node_type {}
variable node_count {}
variable group { default = "" }
variable port {}
variable subnet_group { default = "" }
variable security_group { type = "list" default = [] }
variable az_mode {}
variable zone { default = "" }
variable zones { type = "list" default = [] }

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "cluster_parameters" {
  type        = "list"
  default     = []
}

variable "cluster_family" {
  type        = "string"
  default     = "memcached1.4"
}
