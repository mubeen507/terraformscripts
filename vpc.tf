# VPC
resource "aws_vpc" "small-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "small-vpc"
  }
}

# Public Subnet - A
resource "aws_subnet" "small-pub-sn-A" {
  vpc_id     = aws_vpc.small-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "small-pub-sn-A"
  }
}

# Private Subnet - B
resource "aws_subnet" "small-pvt-sn-B" {
  vpc_id     = aws_vpc.small-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "small-pvt-sn-B"
  }
}

# Intrenet Gateway
resource "aws_internet_gateway" "small-vpc-igw" {
  vpc_id = aws_vpc.small-vpc.id

  tags = {
    Name = "small-vpc-igw"
  }
}

# Public Route Table
resource "aws_route_table" "small-vpc-pub-rt" {
  vpc_id = aws_vpc.small-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.small-vpc-igw.id
  }

  tags = {
    Name = "small-pub-route"
  }
}

# Private Route Table
resource "aws_route_table" "small-vpc-pvt-rt" {
  vpc_id = aws_vpc.small-vpc.id

  tags = {
    Name = "small-pvt-route"
  }
}

# Public Subnet Assocation - A
resource "aws_route_table_association" "small-pub-sn-assoc-A" {
  subnet_id      = aws_subnet.small-pub-sn-A.id
  route_table_id = aws_route_table.small-vpc-pub-rt.id
}

# Private Subnet Assocation - B
resource "aws_route_table_association" "small-pvt-sn-assoc-B" {
  subnet_id      = aws_subnet.small-pvt-sn-B.id
  route_table_id = aws_route_table.small-vpc-pvt-rt.id
}

# Security Group - SSH & HTTP
resource "aws_security_group" "small-sg" {
  name        = "allow_web"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.small-vpc.id

  ingress {
    description      = "SSH from www"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    description      = "HTTP from www"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "small-sg"
  }
}