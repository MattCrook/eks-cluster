resource "aws_rds_cluster" "default" {
     count                           = "${var.enabled == "true" ? 1 : 0}"
     cluster_identifier              = "${var.name}"
     availability_zones              = ["${var.zones}"]
     database_name                   = "${var.db_name}"
     master_username                 = "${var.user}"
     master_password                 = "${var.password}"
     backup_retention_period         = "${var.retention_period}"
     preferred_backup_window         = "${var.backup_window}"
     final_snapshot_identifier       = "${var.name}"
     skip_final_snapshot             = true
     apply_immediately               = true
     snapshot_identifier             = "${var.create_from_snapshot}"
     vpc_security_group_ids          = ["${var.security_groups}"]
     preferred_maintenance_window    = "${var.maintenance_window}"
     db_subnet_group_name            = "${var.subnet_group}"
     db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.default.name}"
     tags                            = "${merge(var.tags, var.rds_cluster_tags, map("Name", format("%s", var.name)))}"
     engine                          = "${var.engine}"
     engine_version                  = "${var.engine_version}"
}


resource "aws_rds_cluster_instance" "default" {
    count                    = "${var.enabled == "true" ? var.cluster_size : 0}"
    identifier               = "${var.name}-${count.index+1}"
    cluster_identifier       = "${aws_rds_cluster.default.id}"
    instance_class           = "${var.instance_type}"
    db_subnet_group_name     = "${var.subnet_group}"
    publicly_accessible      = false
    db_parameter_group_name  = "${aws_db_parameter_group.default.name}"
    tags                     = "${merge(var.tags, var.rds_cluster_tags, map("Name", format("%s", var.name)))}"
    engine                   = "${var.engine}"
    engine_version           = "${var.engine_version}"
}

resource "aws_rds_cluster_parameter_group" "default" {
    count       = "${var.enabled == "true" ? 1 : 0}"
    name        = "${var.name}"
    description = "DB cluster parameter group"
    family      = "${var.cluster_family}"
    parameter   = ["${var.cluster_parameters}"]
    tags        = "${merge(var.tags, var.rds_cluster_tags, map("Name", format("%s", var.name)))}"
}

resource "aws_db_parameter_group" "default" {
    count       = "${var.enabled == "true" ? 1 : 0}"
    name        = "${var.name}"
    description = "DB parameter group"
    family      = "${var.cluster_family}"
    parameter   = ["${var.db_parameters}"]
    tags        = "${merge(var.tags, var.rds_cluster_tags, map("Name", format("%s", var.name)))}"
}
