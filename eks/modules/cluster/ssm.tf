resource "aws_ssm_maintenance_window" "dev" {
  name        = "maintenance-window-eks-dev"
  description = "Maintenance Window for EKS Node updates, Sunday at 5am EST"
  schedule    = "${var.maintenance_window}"
  duration    = 3
  cutoff      = 1
}

resource "aws_ssm_maintenance_window_target" "dev" {
  window_id     = "${aws_ssm_maintenance_window.dev.id}"
  resource_type = "RESOURCE_GROUP"
  # resource_type = "INSTANCE"

  targets {
    # key    = "tag:aws:autoscaling:groupName"
    key    = "resource-groups:Name"
    values = ["${aws_eks_node_group.node_pool.node_group_name}"]
    # values = ["${aws_eks_node_group.node_pool.resources.*.autoscaling_groups.name}"]
  }

  owner_information = "aws dev-developer"
}

resource "aws_ssm_maintenance_window_task" "update_os" {
  window_id = "${aws_ssm_maintenance_window.dev.id}"
  task_type = "RUN_COMMAND"
  task_arn = "AWS-RunPatchBaseline"
  priority = 1
  service_role_arn = "arn:aws:iam::${var.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  # service_role_arn = "${aws_iam_role.node.arn}"
  max_concurrency = "1"
  max_errors = "1"

  targets {
    key = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.dev.id}"]
  }
}
