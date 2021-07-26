resource "aws_vpc" "default" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "default-vpc"
    }
}


resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.default.id

    tags = {
        Name = "default-IGW"
    }
}

resource "aws_route_table" "PublicRT" {
    vpc_id =  aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}

##############################
# Subnet for testing purposes
# Identifiers of EC2 Subnets to associate with the EKS Node Group.
# These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME (where CLUSTER_NAME is replaced with the name of the EKS Cluster).
############################
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "default" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Route table Association with Public Subnet.
resource "aws_route_table_association" "PublicRTassociation" {
    count          = "${length(aws_subnet.default) > 0 ? length(aws_subnet.default) : 0}"
    subnet_id      = "${element(aws_subnet.default.*.id, count.index)}"
    route_table_id = "${aws_route_table.PublicRT.id}"
 }
