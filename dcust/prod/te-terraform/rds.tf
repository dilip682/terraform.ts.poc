resource "aws_db_subnet_group" "default" {
  name       = "prod"
  subnet_ids = ["${var.sub_app}", "${var.sub_int}"]

  tags {
    Name = "RDS subnet group"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage       = 50                                                                # gigabytes
  backup_retention_period = 7                                                                 # in days
  db_subnet_group_name    = "${aws_db_subnet_group.default.id}"
  engine                  = "oracle-se2"
  engine_version          = "12.1.0.2.v12"
  license_model           = "license-included"
  identifier              = "brixon-prod-db"
  instance_class          = "db.t2.large"
  multi_az                = false
  name                    = "PROD"
  password                = "${trimspace(file("${path.module}/secrets/mydb1-password.txt"))}"
  port                    = 1521
  publicly_accessible     = false
  storage_encrypted       = true                                                              # you should always do this
  storage_type            = "gp2"
  username                = "admin"
  skip_final_snapshot     = true
  kms_key_id              = "${aws_kms_key.my_kms.arn}"
  vpc_security_group_ids  = ["${module.RDS-sg.this_security_group_id}"]
}
