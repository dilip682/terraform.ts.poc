#This file is going to create application load balancer.
resource "aws_alb" "alb" {
  name            = "${var.name}-ELB"
  internal        = false
  security_groups = ["${module.elb-sg.this_security_group_id}"]
  subnets         = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]

  tags {
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_alb_target_group" "alb_app_http" {
  name     = "${var.name}-${var.environment}-app"
  vpc_id   = "${aws_vpc.main.id}"
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
  vpc_id   = "${aws_vpc.main.id}"
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

resource "aws_alb_target_group" "noaccess" {
  name     = "No-Acess"
  vpc_id   = "${aws_vpc.main.id}"
  port     = "80"
  protocol = "HTTP"

  health_check {
    path                = "/"
    port                = "80"
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

#resource "aws_alb_target_group_attachment" "alb_backend-03_http" {
#  target_group_arn = "${aws_alb_target_group.noaccess.arn}"
#  port             = "8080"
#}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"
#  ssl_policy        = "ELBSecurityPolicy-2015-05"
#  certificate_arn   = "${var.ssl_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.noaccess.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "int" {
  listener_arn = "${aws_alb_listener.alb_listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_int_http.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/dev/services/*"]
  }
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = "${aws_alb_listener.alb_listener.arn}"
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_app_http.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/dev/*"]
  }
}
