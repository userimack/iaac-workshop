resource "aws_security_group" "frontend_clb" {
  vpc_id      = aws_vpc.custom_vpc.id
  name        = "frontend-clb"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "frontend-clb"
    }
  )
}


resource "aws_security_group" "frontend" {
  vpc_id      = aws_vpc.custom_vpc.id
  name        = "frontend-security-group"
  description = "security group for backend instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_clb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.252.166.63/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["103.252.166.63/32"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "frontend-sg"
    }
  )
}


resource "aws_security_group" "backend_clb" {
  vpc_id      = aws_vpc.custom_vpc.id
  name        = "backend-clb-sg"
  description = "security group for load balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 9966
    to_port         = 9966
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    from_port   = 9966
    to_port     = 9966
    protocol    = "tcp"
    cidr_blocks = ["103.252.166.63/32"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "backend-lb"
    }
  )
}


resource "aws_security_group" "backend" {
  vpc_id      = aws_vpc.custom_vpc.id
  name        = "backend-security-group"
  description = "security group for backend instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 9966
    to_port         = 9966
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_clb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.252.166.63/32"]
  }

  ingress {
    from_port   = 9966
    to_port     = 9966
    protocol    = "tcp"
    cidr_blocks = ["103.252.166.63/32"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "backend-sg"
    }
  )
}


resource "aws_security_group" "database" {
  vpc_id      = aws_vpc.custom_vpc.id
  name        = "database-security-group"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  depends_on = [
    aws_security_group.backend
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "database-security-groups"
    }
  )
}
