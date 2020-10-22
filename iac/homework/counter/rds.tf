resource "aws_security_group" "lab-counter-database-sg" {
  description = "Open database for access"
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [
      aws_security_group.lab-counter-public-access-sg.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
}

resource "aws_db_instance" "lab-counter-db" {
  identifier = "lab-counter-db"
  name = var.db_name
  engine = "MySQL"
  multi_az = false
  publicly_accessible = true
  username = var.db_username
  password = var.db_password
  instance_class = var.db_instance_type
  allocated_storage = var.db_allocated_storage
  snapshot_identifier = "arn:aws:rds:us-west-2:827408179661:snapshot:lab-database-to-deploy"
  depends_on = [
    aws_security_group.lab-counter-database-sg]
  vpc_security_group_ids = [
    aws_security_group.lab-counter-database-sg.id]
  skip_final_snapshot = true
  # disable backups to create DB faster
  backup_retention_period = 0
  # we need to clean everything
  delete_automated_backups = true

  tags = {
    Lab = "true"
  }

  # enabled_cloudwatch_logs_exports = ["audit", "general"]
}

output "db_endpoint_address" {
  value = aws_db_instance.lab-counter-db.address
}

output "db_endpoint_port" {
  value = aws_db_instance.lab-counter-db.port
}