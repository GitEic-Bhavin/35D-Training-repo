resource "aws_vpc" "newvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }

}

# Create Subnets

resource "aws_subnet" "pub-sub" {
  vpc_id            = aws_vpc.newvpc.id
  cidr_block        = var.pub_sub_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = var.pub_sub_name
  }

}
resource "aws_subnet" "pvt-sub" {
  vpc_id            = aws_vpc.newvpc.id
  cidr_block        = var.pvt_sub_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = var.pvt_sub_name
  }
}
resource "aws_subnet" "pvt-sub2" {
  vpc_id = aws_vpc.newvpc.id
  cidr_block = var.pvt_sub_cidr2
  availability_zone = "us-west-2a"

  tags = {
    Name = var.pvt_sub2_name
  }
}

# Create Interent Gateway

resource "aws_internet_gateway" "igw_bhavin" {
  vpc_id = aws_vpc.newvpc.id

  tags = {
    Name = var.igw_name
  }

}

# Create Route Table for Public Subnet
resource "aws_route_table" "pub-rtb" {
  vpc_id = aws_vpc.newvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_bhavin.id
  }

  tags = {
    Name = var.pub_rtb_name
  }

}

# Public Subnet Associations
resource "aws_route_table_association" "pub_rtb_assoc" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.pub-rtb.id

}


# Create Private Route Table
resource "aws_route_table" "pvt-rtb" {
  vpc_id = aws_vpc.newvpc.id

  tags = {
    Name = var.pvt_rtb_name
  }

}

resource "aws_route_table_association" "pvt_rtb_assoc" {
  subnet_id      = [aws_subnet.pvt-sub.id, aws_subnet.pvt-sub2.id]
  route_table_id = aws_route_table.pvt-rtb.id

}