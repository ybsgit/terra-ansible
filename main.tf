locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {
  state = "available"
}
resource "random_id" "random" {
  byte_length = 2
}
resource "aws_vpc" "mtc_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      Name = "mtc_vpc-${random_id.random.dec}"
  }
  lifecycle {
    create_before_destroy = true 
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_igw-${random_id.random.dec}"
  }
}

resource "aws_route" "mtc_public_rt" {
  route_table_id            = aws_route_table.mtc_route_table.id 
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table" "mtc_route_table" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_rt-${random_id.random.dec}"
  }
}

resource "aws_default_route_table" "mtc_vpc_private_rt" {
   default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id
     tags = {
    Name = "mtc_private_rt-${random_id.random.dec}"
  }
}


resource "aws_subnet" "mtc_public_subnet" {
  count = length (local.azs) 
  vpc_id     =  aws_vpc.mtc_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)
  map_public_ip_on_launch = true
  availability_zone = local.azs[count.index]
  tags = {
    Name = "mtc_public_subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "mtc_private_subnet" {
  count = length (local.azs) 
  vpc_id     =  aws_vpc.mtc_vpc.id
 cidr_block = cidrsubnet(var.vpc_cidr,8,length(local.azs)+count.index)
  map_public_ip_on_launch = true
  availability_zone = local.azs[count.index]
  tags = {
    Name = "mtc_private_subnet-${count.index + 1}"
  }
}