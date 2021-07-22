provider "aws" {
    region = "us-east-1"
}

module "vpc" {
    source = "../../../modules/vpc"

    name                               = "${var.region}-dev-vpc"
    zones                              = ["us-east-1a", "us-east-1b"]
    # public_subnets                     = ["10.0.0.128/26"]
    # private_subnets                    = ["10.0.0.192/26"]
    range                              = "10.21.190.0/23"
    public_subnets                     = ["10.21.190.0/26", "10.21.190.64/26"]
    private_subnets                    = ["10.21.190.128/25", "10.21.191.0/25"]
    create_vpc                         = true
    enable_nat_gateway                 = true
    single_nat_gateway                 = true
    one_nat_gateway_per_az             = true
    enable_vpn_gateway                 = true
    enable_dns_hostnames               = true
    enable_dns_support                 = true
    external_nat_ip_ids                = []
    map_public_ip_on_launch            = true
    reuse_nat_ips                      = false
    propagate_public_route_tables_vgw  = false
    propagate_private_route_tables_vgw = false
    public_subnet_tags                 = "${var.public_subnet_tags}"
    private_subnet_tags                = "${var.private_subnet_tags}"
    public_route_table_tags            = "${var.public_route_table_tags}"
    private_route_table_tags           = "${var.private_route_table_tags}"
    vpc_tags                           = "${var.vpc_tags}"
    default_route_table_tags           = "${var.default_route_table_tags}"

    tags = {
        Name = "local-dev-vpc"
    }
}
