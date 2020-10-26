resource "aws_security_group" "DBEC2SecurityGroup" {
  description = "Open database for access"
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [
      aws_security_group.WordpressSecurityGroup.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.VPC.id
}

resource "aws_db_instance" "DBInstance" {
  name = var.db_name
  engine = "MySQL"
  multi_az = false
  username = var.db_username
  password = var.db_password
  instance_class = var.db_instance_type
  allocated_storage = var.db_allocated_storage
  depends_on = [
    aws_security_group.DBEC2SecurityGroup]
  vpc_security_group_ids = [
    aws_security_group.DBEC2SecurityGroup.id]
  db_subnet_group_name = aws_db_subnet_group.DBSubnetGroup.name
  skip_final_snapshot = true
}
