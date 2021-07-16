provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  create_vpc = true
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway = true
  name = ""
  zones = []
  public_subnets = []
  private_subnets = []
  enable_dns_hostnames = true
  enable_dns_support = true
  external_nat_ip_ids = []
  map_public_ip_on_launch = true
  reuse_nat_ips = false
  propagate_public_route_tables_vgw = false
  propagate_private_route_tables_vgw = false

  public_subnet_tags = {}
  private_subnet_tags = {}
  public_route_table_tags = {}
  private_route_table_tags = {}
  vpc_tags = {}
  default_route_table_tags = {}
  tags = {}
}

module "cluster" {
  cluster_name = "EKSCluster"
  vpc_id = "${module.vpc.vpc_id}"
  private_subnets = "${module.vpc.private_subnets}"
  instance_type = "t2.meduim"
  log_retention_days = 5
  instance_count = 2
  worker_security_groups = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
  master_security_groups = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
}


resource "aws_security_group" "allow_all_inbound" {
    name        = "${var.ingress_security_group_name}"
    vpc_id      = "${module.vpc.vpc_id}"

    ingress {
        description = "http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_inbound"
    }
}

resource "aws_security_group" "allow_all_outbound" {
    name        = "${var.egress_security_group_name}"
    vpc_id      = "${module.vpc.vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_outbound"
    }
}

resource "aws_security_group" "allow_ssh" {
    name        = "${var.ssh_security_group_name}"
    vpc_id      = "${module.vpc.vpc_id}"

    ingress {
        description = "ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
    }
}
