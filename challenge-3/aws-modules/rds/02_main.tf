resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "el-challenge"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az             = true
  port                 = 3306
  
  availability_zone =""
  db_subnet_group_name  = aws_db_subnet_group.this.id
  deletion_protection = false

  tags              = {
    Name = "mysql-challenge"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "mysql_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}