variable "name" {
  type        = "string"
  description = "Name of the application"
}

variable "zones" {
  type        = "list"
  description = "List of Availability Zones that instances in the DB cluster can be created in"
}

variable "instance_type" {
  type        = "string"
  default     = "db.t2.small"
  description = "Instance type to use"
}

variable "cluster_size" {
  type        = "string"
  default     = "2"
  description = "Number of DB instances to create in the cluster"
}

variable "db_name" {
  type        = "string"
  description = "Database name"
}

variable "db_port" {
  type        = "string"
  default     = "3306"
  description = "Database port"
}

variable "user" {
  type        = "string"
  default     = "admin"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "password" {
  type        = "string"
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "retention_period" {
  type        = "string"
  default     = "5"
  description = "Number of days to retain backups for"
}

variable "backup_window" {
  type        = "string"
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "maintenance_window" {
  type        = "string"
  default     = "wed:03:00-wed:04:00"
  description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "rds_cluster_tags" {
  description = "Additional tags for the rds cluster"
  default     = {}
}

variable "cluster_parameters" {
  type        = "list"
  default     = []
  description = "List of DB parameters to apply"
}

variable "db_parameters" {
  type        = "list"
  default     = []
  description = "List of DB parameters to apply"
}

variable "cluster_family" {
  type        = "string"
  default     = "aurora-mysql5.7"
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = "string"
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-postgresql`"
}

variable "engine_version" {
  type        = "string"
  default     = ""
  description = "The version number of the database engine to use"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "subnet_group" {
  description = "Subnet group name"
}

variable "security_groups" {
  type = "list"
  description = "Security group id"
}

variable "create_from_snapshot" {
  description = "Optionally create from snapshot"
  default = ""
}
