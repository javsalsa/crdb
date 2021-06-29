resource "aws_lb" "crdb-nlb" {
  name               = "crdb-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [var.subnet1,var.subnet2,var.subnet3]

  enable_deletion_protection = true

  tags = {
    Environment = "crdb-poc"
  }
}

resource "aws_lb_target_group" "crdbnode-26257-tg" {
  name        = "crdbnode-26257-tg"
  port        = 26257
  protocol    = "TCP"
  vpc_id      = var.vpc
  health_check {
    path = "/health?ready=1"
    port = 8080
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 6
    interval = 30
    matcher = "200-399"
  }
}

resource "aws_lb_target_group" "crdbnode-8080-tg" {
  name        = "crdbnode-8080-tg"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = var.vpc
  health_check {
    path = "/health?ready=1"
    port = 8080
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 6
    interval = 30
    matcher = "200-399"
  }
}

resource "aws_lb_listener" "crdbnode-26257-tg" {
  load_balancer_arn = aws_lb.crdb-nlb.arn
  port              = "26257"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crdbnode-26257-tg.arn
  }
}

resource "aws_lb_listener" "crdbnode-8080-tg" {
  load_balancer_arn = aws_lb.crdb-nlb.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crdbnode-8080-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "crdbnode-26257-attachment-1" {
  target_group_arn = aws_lb_target_group.crdbnode-26257-tg.arn
  target_id        = aws_instance.node1.id
  port             = 26257
}

resource "aws_lb_target_group_attachment" "crdbnode-26257-attachment-2" {
  target_group_arn = aws_lb_target_group.crdbnode-26257-tg.arn
  target_id        = aws_instance.node2.id
  port             = 26257
}

resource "aws_lb_target_group_attachment" "crdbnode-26257-attachment-3" {
  target_group_arn = aws_lb_target_group.crdbnode-26257-tg.arn
  target_id        = aws_instance.node3.id
  port             = 26257
}

resource "aws_lb_target_group_attachment" "crdbnode-8080-attachment-1" {
  target_group_arn = aws_lb_target_group.crdbnode-8080-tg.arn
  target_id        = aws_instance.node1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "crdbnode-8080-attachment-2" {
  target_group_arn = aws_lb_target_group.crdbnode-8080-tg.arn
  target_id        = aws_instance.node2.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "crdbnode-8080-attachment-3" {
  target_group_arn = aws_lb_target_group.crdbnode-8080-tg.arn
  target_id        = aws_instance.node3.id
  port             = 8080
}
