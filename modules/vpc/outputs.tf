output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${element(concat(aws_vpc.default.*.id, list("")), 0)}"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = "${element(concat(aws_vpc.default.*.cidr_block, list("")), 0)}"
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = "${element(concat(aws_vpc.default.*.default_security_group_id, list("")), 0)}"
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = "${element(concat(aws_vpc.default.*.default_network_acl_id, list("")), 0)}"
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = "${element(concat(aws_vpc.default.*.default_route_table_id, list("")), 0)}"
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = "${element(concat(aws_vpc.default.*.instance_tenancy, list("")), 0)}"
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = "${element(concat(aws_vpc.default.*.enable_dns_support, list("")), 0)}"
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = "${element(concat(aws_vpc.default.*.enable_dns_hostnames, list("")), 0)}"
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with default VPC"
  value       = "${element(concat(aws_vpc.default.*.main_route_table_id, list("")), 0)}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${aws_subnet.private.*.id}"
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = "${aws_subnet.private.*.cidr_block}"
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = "${aws_subnet.public.*.id}"
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = "${aws_subnet.public.*.cidr_block}"
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with default VPC"
  value       = "${element(concat(aws_vpc.default.*.main_route_table_id, list("")), 0)}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${aws_subnet.private.*.id}"
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = "${aws_subnet.private.*.cidr_block}"
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = "${aws_subnet.public.*.id}"
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = "${aws_subnet.public.*.cidr_block}"
}


output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = ["${aws_route_table.private.*.id}"]
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = ["${aws_eip.nat.*.id}"]
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${aws_eip.nat.*.public_ip}"]
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = ["${aws_nat_gateway.default.*.id}"]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = "${element(concat(aws_internet_gateway.default.*.id, list("")), 0)}"
}
