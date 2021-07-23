###################################
# Default VPC for testing purposes
##################################
data "aws_vpc" "default" {
    # Directs TF to look up the Default VPC in your AWS account.
    default = true
}

# Look up the subnets within your VPC.
data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "default" {
  for_each = data.aws_subnet_ids.default.ids
  id       = each.value
}
