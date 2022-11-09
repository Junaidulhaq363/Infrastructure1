resource "aws_lb" "test" {
  name               = "Elb-webserver"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver.id]
  subnets            = [aws_subnet.first.id, aws_subnet.Second.id]

  


  tags = {
    Environment = "Test"
  }
}