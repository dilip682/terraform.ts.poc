#This file is going to create application load balancer.
resource "aws_alb_target_group" "alb_app_http" {
  name     = "${var.name}-${var.environment}-app"
  vpc_id   = "${var.vpc_id}"
  port     = "8080"
  protocol = "HTTP"

  health_check {
    path                = "/index.jsp"
    port                = "8080"
    protocol            = "HTTP"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    timeout             = "5"
    matcher             = "200-308"
  }
}

resource "aws_alb_target_group" "alb_int_http" {
  name     = "${var.name}-${var.environment}-int"
  vpc_id   = "${var.vpc_id}"
  port     = "8080"
  protocol = "HTTP"

  health_check {
    path                = "/index.jsp"
    port                = "8080"
    protocol            = "HTTP"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    timeout             = "5"
    matcher             = "200-308"
  }
}


resource "aws_alb_target_group_attachment" "alb_backend-01_http" {
  target_group_arn = "${aws_alb_target_group.alb_app_http.arn}"
  target_id        = "${aws_instance.app1.id}"
  port             = "8080"
}

resource "aws_alb_target_group_attachment" "alb_backend-02_http" {
  target_group_arn = "${aws_alb_target_group.alb_int_http.arn}"
  target_id        = "${aws_instance.index1.id}"
  port             = "8080"
}



resource "aws_lb_listener_rule" "int" {
  listener_arn = "${var.listener_arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_int_http.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/test/services/*"]
  }
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = "${var.listener_arn}"
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_app_http.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/test/*"]
  }
}
