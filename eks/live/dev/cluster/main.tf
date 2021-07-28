provider "aws" {
  region  = "${var.region}"
}

terraform {
  required_version = ">= 0.12"
}


module "cluster" {
  source = "../../../modules/cluster"

  cluster_name              = "EKSCluster"
  region                    = "${var.region}"
  ami_id                    = "ami-0eeeef929db40543c"
  ami_type                  = "AL2_x86_64"
  disk_size                 = 20
  # instance_type           = "t2.medium"
  instance_types            = ["t3.medium"]
  # vpc_id                  = "${data.aws_vpc.default.id}"
  # private_subnets         =   ["subnet-1da7eb3c", "subnet-4a337115", "subnet-531a5b35"]
  log_retention_days        = 5
  instance_count            = 2
  name                      = "${var.name}"
  node_group_name           = "EKSCluster-Node-Group"
  create_security_group     = "${var.create_security_group}"
  description               = "${var.description}"
  endpoint_private_access   = true
  endpoint_public_access    = true
  desired_size              = 2
  max_size                  = 3
  min_size                  = 1
  # source_security_group_id = "${aws_security_group.worker.id}"
  tags                      = {for k, v in var.tags : k => v}
}

    # vpc_id                 = "${module.vpc.vpc_id}"
    # private_subnets        = "${module.vpc.private_subnets}"
    # private_subnets        = tolist(data.aws_subnet_ids.default.ids)
    # worker_security_groups = [aws_security_group.default[count.index].id]
    # master_security_groups = [aws_security_group.default[count.index].id]
