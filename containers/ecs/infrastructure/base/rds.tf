resource "aws_security_group" "app_db_sg" {
  description = "Open database for access"
  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = [
      var.vpc_cidr_block]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  vpc_id = aws_vpc.default.id
}

resource "aws_db_subnet_group" "default" {
  name = "main"
  subnet_ids = [
    aws_subnet.private.id, aws_subnet.private2.id]
}

resource "aws_db_instance" "db" {
  name = var.db_name
  engine = "postgres"
  multi_az = false
  username = var.db_username
  password = var.db_password
  instance_class = var.db_instance_type
  allocated_storage = var.db_allocated_storage
  depends_on = [
    aws_security_group.app_db_sg]
  vpc_security_group_ids = [
    aws_security_group.app_db_sg.id]
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}
