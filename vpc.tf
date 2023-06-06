# VPC
resource "aws_vpc" "big-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "big-vpc"
  }
}
