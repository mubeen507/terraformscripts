# Setup EC2 Instance
resource "aws_instance" "small-ec2" {
  ami           = "ami-0430580de6244e02e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.small-pub-sn-A.id
  vpc_security_group_ids = [aws_security_group.small-sg.id]
  key_name = "ravi-aws-key"
  user_data = file("webapp.sh")
  tags = {
    Name = "small-ec2"
  }
}