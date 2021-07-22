variable "region" {
  description = "AWS region of vpc"
  type        = string
  default     = "us-east-1"
}


variable "public_subnet_tags" {
  description = "AWS region of vpc"
  type        = map(string)
  default     = {}
}
variable "private_subnet_tags" {
  description = "AWS region of vpc"
  type        = map(string)
  default     = {}
}
variable "public_route_table_tags" {
  description = "AWS region of vpc"
  type        = map(string)
  default     = {}
}
variable "private_route_table_tags" {
  description = "AWS region of vpc"
  type        = map(string)
  default     = {}
}
variable "vpc_tags" {
  description = "AWS region of vpc"
  type        = map(string)
  default     = {}
}
variable "default_route_table_tags" {
  description = "AWS region of vpc"
  type        = map(string)
  default     = {}
}
