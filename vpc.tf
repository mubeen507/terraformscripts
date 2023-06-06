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

# Private Subnet - A
resource "aws_subnet" "big-pvt-sn-A" {
  vpc_id     = aws_vpc.big-vpc.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "big-pvt-sn-A"
  }
}


# Private Subnet - B
resource "aws_subnet" "big-pvt-sn-B" {
  vpc_id     = aws_vpc.big-vpc.id
  cidr_block = "10.0.48.0/20"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "big-pvt-sn-B"
  }
}

# Intrenet Gateway
resource "aws_internet_gateway" "big-vpc-igw" {
  vpc_id = aws_vpc.big-vpc.id

  tags = {
    Name = "big-vpc-igw"
  }
}

# Public Route Table
resource "aws_route_table" "big-vpc-pub-rt" {
  vpc_id = aws_vpc.big-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.big-vpc-igw.id
  }

  tags = {
    Name = "big-pub-route"
  }
}

# Private Route Table
resource "aws_route_table" "big-vpc-pvt-rt" {
  vpc_id = aws_vpc.big-vpc.id

  tags = {
    Name = "big-pvt-route"
  }
}

# Public Subnet Assocation - A
resource "aws_route_table_association" "big-pub-sn-assoc-A" {
  subnet_id      = aws_subnet.big-pub-sn-A.id
  route_table_id = aws_route_table.big-vpc-pub-rt.id
}

# Public Subnet Assocation - B
resource "aws_route_table_association" "big-pub-sn-assoc-B" {
  subnet_id      = aws_subnet.big-pub-sn-B.id
  route_table_id = aws_route_table.big-vpc-pub-rt.id
}

# Private Subnet Assocation - A
resource "aws_route_table_association" "big-pvt-sn-assoc-A" {
  subnet_id      = aws_subnet.big-pvt-sn-A.id
  route_table_id = aws_route_table.big-vpc-pvt-rt.id
}

# Private Subnet Assocation - B
resource "aws_route_table_association" "big-pvt-sn-assoc-B" {
  subnet_id      = aws_subnet.big-pvt-sn-B.id
  route_table_id = aws_route_table.big-vpc-pvt-rt.id
}

# Security Group - SSH & HTTP
resource "aws_security_group" "big-sg" {
  name        = "allow_web"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.big-vpc.id

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
    Name = "big-sg"
  }
}