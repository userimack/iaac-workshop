resource "aws_elb" "backend_clb" {
  name            = "petclinic-ba"
  subnets         = flatten([aws_subnet.public.*.id])
  security_groups = [aws_security_group.backend_clb.id]

  listener {
    instance_port     = 9966
    instance_protocol = "http"
    lb_port           = 9966
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:9966/petclinic/swagger-ui.html"
    interval            = 30
  }
  instances = flatten([aws_instance.backend[*].id])

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = merge(
    var.common_tags,
    {
      Name = "backend-clb"
    }
  )
}

resource "aws_elb" "frontend_clb" {
  name            = "petclinic-fr"
  subnets         = flatten([aws_subnet.public.*.id])
  security_groups = [aws_security_group.frontend_clb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/petclinic/index.html"
    interval            = 30
  }

  instances = flatten([aws_instance.frontend[*].id])

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = merge(
    var.common_tags,
    {
      Name = "frontend-clb"
    }
  )
}
