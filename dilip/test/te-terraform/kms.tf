resource "aws_kms_key" "my_kms" {
  description             = "KMS for the customer mentioned in Tags"
  deletion_window_in_days = 30

  tags {
    Name       = "${var.name}-${var.environment}-kms"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_kms_alias" "my_kms" {
  name          = "alias/${var.name}-${var.environment}-kms"
  target_key_id = "${aws_kms_key.my_kms.key_id}"
}
