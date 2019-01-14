#Bastion server
resource "aws_instance" "example" {
  ami           = "${var.bastion}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${module.allow-ssh.this_security_group_id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  tags {
    Name       = "${var.name}-Bastion"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }

  user_data = <<HEREDOC
  #!/bin/bash
  yum update -y
  HEREDOC
}


resource "aws_instance" "oracle" {
  ami           = "${var.oracle}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-private-1.id}"

  # the security group
  vpc_security_group_ids = ["${module.oracle-sg.this_security_group_id}"]

  root_block_device {
    volume_size = "30"
  }

  # the public SSH keyel
  key_name = "${aws_key_pair.mykeypair.key_name}"

  tags {
    Name       = "${var.name}-${var.environment}-Oracle-Tools"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}
