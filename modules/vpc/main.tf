resource "aws_vpc" "default" {
  count = "${var.create_vpc ? 1 : 0}"

  # cidr_block           = "${var.range}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = "${merge(var.tags, var.vpc_tags, map("Name", format("%s", var.name)))}"
}

resource "aws_internet_gateway" "default" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.default.id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_route_table" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.default.id}"

  tags = "${merge(var.tags, var.public_route_table_tags, map("Name", format("%s-public", var.name)))}"
}

resource "aws_route" "public_internet_gateway" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "private" {
  count = "${var.create_vpc && local.max_subnet_length > 0 ? local.nat_gateway_count : 0}"

  vpc_id = "${aws_vpc.default.id}"

  tags = "${merge(var.tags, var.private_route_table_tags, map("Name", (var.single_nat_gateway ? "${var.name}-private" : format("%s-private-%s", var.name, element(var.zones, count.index)))))}"

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = ["propagating_vgws"]
  }
}

resource "aws_subnet" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 && (!var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.zones)) ? length(var.public_subnets) : 0}"

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.zones, count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = "${merge(var.tags, var.public_subnet_tags, map("Name", format("%s-public-%s", var.name, element(var.zones, count.index))))}"
}

resource "aws_subnet" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.zones, count.index)}"

  tags = "${merge(var.tags, var.private_subnet_tags, map("Name", format("%s-private-%s", var.name, element(var.zones, count.index))))}"
}

locals {
  nat_gateway_ips = "${split(",", (var.reuse_nat_ips ? join(",", var.external_nat_ip_ids) : join(",", aws_eip.nat.*.id)))}"
}

resource "aws_eip" "nat" {
  count = "${var.create_vpc && (var.enable_nat_gateway && !var.reuse_nat_ips) ? local.nat_gateway_count : 0}"

  vpc = true

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.name, element(var.zones, (var.single_nat_gateway ? 0 : count.index)))))}"
}

resource "aws_nat_gateway" "default" {
  count = "${var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0}"

  allocation_id = "${element(local.nat_gateway_ips, (var.single_nat_gateway ? 0 : count.index))}"
  subnet_id     = "${element(aws_subnet.public.*.id, (var.single_nat_gateway ? 0 : count.index))}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.name, element(var.zones, (var.single_nat_gateway ? 0 : count.index)))))}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_route" "private_nat_gateway" {
  count = "${var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.default.*.id, count.index)}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, (var.single_nat_gateway ? 0 : count.index))}"
}

resource "aws_route_table_association" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


# For use of VPN. The following resources should be created.

// resource "aws_vpn_gateway" "default" {
//   count = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"

//   vpc_id = "${aws_vpc.default.id}"
//   amazon_side_asn = "${var.vgw_asn}"

//   tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
// }

// resource "aws_vpn_gateway_attachment" "default" {
//   count = "${var.vpn_gateway_id != "" ? 1 : 0}"

//   vpc_id         = "${aws_vpc.default.id}"
//   vpn_gateway_id = "${var.vpn_gateway_id}"
// }

// resource "aws_vpn_gateway_route_propagation" "public" {
//   count = "${var.create_vpc && var.propagate_public_route_tables_vgw && (var.enable_vpn_gateway  || var.vpn_gateway_id != "") ? 1 : 0}"

//   route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
//   vpn_gateway_id = "${element(concat(aws_vpn_gateway.default.*.id, aws_vpn_gateway_attachment.default.*.vpn_gateway_id), count.index)}"
// }

// resource "aws_vpn_gateway_route_propagation" "private" {
//   count = "${var.create_vpc && var.propagate_private_route_tables_vgw && (var.enable_vpn_gateway || var.vpn_gateway_id != "") ? length(var.private_subnets) : 0}"

//   route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
//   vpn_gateway_id = "${element(concat(aws_vpn_gateway.default.*.id, aws_vpn_gateway_attachment.default.*.vpn_gateway_id), count.index)}"
// }
