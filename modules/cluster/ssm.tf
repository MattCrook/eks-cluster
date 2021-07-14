resource "aws_ssm_maintenance_window" "node" {
  name = "maintenance-window-eks-node"
  # description = "Maintenance Window for EKS Node updates, Sunday at 5am EST"
  schedule = "${var.maintenance_window}"
  duration = 3
  cutoff = 1
}

resource "aws_ssm_maintenance_window_target" "node" {
  window_id = "${aws_ssm_maintenance_window.node.id}"
  resource_type = "INSTANCE"
  targets {
    key = "tag:aws:autoscaling:groupName"
    values = ["${aws_autoscaling_group.node.name}"]
  }
  owner_information = "aws dev-developer"
}

resource "aws_ssm_maintenance_window_task" "update_os" {
  window_id = "${aws_ssm_maintenance_window.node.id}"
  task_type = "RUN_COMMAND"
  task_arn = "AWS-RunPatchBaseline"
  priority = 1
  service_role_arn = "arn:aws:iam::${var.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  max_concurrency = "1"
  max_errors = "1"
  targets {
    key = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.node.id}"]
  }
