resource "aws_subnet" "first" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone       = "us-east-1a"

  tags = {
    Name = "First"
  }
}

resource "aws_subnet" "Second" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Second"
  }
}