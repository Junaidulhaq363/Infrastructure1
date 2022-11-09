resource "aws_instance" "ec2-1" {
  ami                    = "ami-09d3b3274b6c5d4aa"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = aws_subnet.first.id
  user_data              = file("install_nginx.sh")

  tags = {
    Name = "first-instance"
  }
}

resource "aws_instance" "ec2-2" {
  ami                    = "ami-09d3b3274b6c5d4aa"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = aws_subnet.Second.id
  user_data              = file("install_nginx.sh")

  tags = {
    Name = "second-instance"
  }
}