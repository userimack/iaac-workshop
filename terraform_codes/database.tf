resource "aws_db_subnet_group" "private" {
  subnet_ids = concat(aws_subnet.private.*.id)

  tags = merge(
    var.common_tags,
    {
      Name = "Private Subnet"
    }
  )
}

resource "aws_db_instance" "this" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "12.2"
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = var.db_user
  password                = var.db_master_password
  db_subnet_group_name    = aws_db_subnet_group.private.id
  parameter_group_name    = "default.postgres12"
  skip_final_snapshot     = true
  deletion_protection     = false
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = 0
  availability_zone       = var.availability_zone
  vpc_security_group_ids  = [aws_security_group.database.id]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-db"
    }
  )
}
