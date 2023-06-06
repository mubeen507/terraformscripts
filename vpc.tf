# VPC
resource "aws_vpc" "big-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "big-vpc"
  }
}

# Public Subnet - A
resource "aws_subnet" "big-pub-sn-A" {
  vpc_id     = aws_vpc.big-vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "big-pub-sn-A"
  }
}

# Public Subnet - B
resource "aws_subnet" "big-pub-sn-B" {
  vpc_id     = aws_vpc.big-vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "big-pub-sn-B"
  }
}
