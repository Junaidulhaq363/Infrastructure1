resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  description   = "it is an auto scaling group of webserver instance"
  image_id      = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  #security_groups = ["${aws_security_group.webserver.id}"]

  vpc_security_group_ids = ["sg-05875950aff2e46ee","sg-0aef576c39c6b3e81"]
  key_name               = "new"
  user_data              = filebase64("${path.module}/install_nginx.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  monitoring {
    enabled = true
  }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.webserver.id]
#   }

}

resource "aws_autoscaling_group" "bar" {
#   availability_zones  = ["us-east-1"]
    vpc_zone_identifier = [aws_subnet.first.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
    name                      = "test"
 

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.bar.name
  lb_target_group_arn    = aws_lb_target_group.test.arn
}

resource "aws_autoscaling_policy" "scale-up" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name
}


resource "aws_autoscaling_policy" "scale-down" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name
}



resource "aws_cloudwatch_metric_alarm" "scale-up-alarm" {
  alarm_name          = "scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = "aws_autoscaling_group.bar.name"
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale-up.arn]
}




resource "aws_cloudwatch_metric_alarm" "scale-down-alarm" {
  alarm_name          = "scale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bar.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale-down.arn]
}
