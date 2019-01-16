resource "aws_efs_file_system" "efs-example" {
  creation_token = "efs-example-1"

  encrypted  = "True"
  kms_key_id = "${aws_kms_key.my_kms.arn}"

  tags {
    Name       = "${var.name}-${var.environment}-EFS"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_efs_mount_target" "efs-example-private-1" {
  file_system_id  = "${aws_efs_file_system.efs-example.id}"
  subnet_id       = "${aws_subnet.main-private-1.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]     # refers to a security group that gets access to this EFS share
}

resource "aws_efs_mount_target" "efs-example-private-2" {
  file_system_id  = "${aws_efs_file_system.efs-example.id}"
  subnet_id       = "${aws_subnet.main-private-2.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}
