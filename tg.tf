resource "aws_lb_target_group" "test" {
  name        = "tf-example-lb-tg"
  
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
}

# resource "aws_vpc" "main" {
#   cidr_block = "0.0.0.0/0"
# }


resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.ec2-1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.ec2-2.id
  port             = 80
}
//check karna h