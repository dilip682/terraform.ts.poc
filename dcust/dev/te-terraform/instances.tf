#Bastion server
resource "aws_instance" "example" {
  # ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  ami           = "ami-942dd1f6"
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

data "template_file" "user_data1" {
  template = "${file("app.sh")}"

  vars {
    fs_name = "${aws_efs_file_system.efs-example.id}"
    region  = "${var.AWS_REGION}"
  }
}

resource "aws_instance" "app1" {
  # ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  ami           = "ami-942dd1f6"
  instance_type = "t2.large"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-private-1.id}"
  user_data = "${data.template_file.user_data1.rendered}"

  # the security group
  vpc_security_group_ids = ["${module.app1-sg.this_security_group_id}"]

  root_block_device {
    volume_size = "8"
  }

  # the public SSH keyel
  key_name = "${aws_key_pair.mykeypair.key_name}"

  tags {
    Name       = "${var.name}-${var.environment}01"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

# data "template_file" "user_data2" {
#   template = "${file("app.sh")}"

#   vars {
#     fs_name = "${aws_efs_file_system.efs-example.id}"
#     region  = "${var.AWS_REGION}"
#   }
# }

resource "aws_instance" "index1" {
  # ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  ami           = "ami-942dd1f6"
  instance_type = "t2.large"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-private-1.id}"
  user_data = "${data.template_file.user_data1.rendered}"

  # the security group
  vpc_security_group_ids = ["${module.app1-sg.this_security_group_id}"]

  root_block_device {
    volume_size = "20"
  }

  # the public SSH keyel
  key_name = "${aws_key_pair.mykeypair.key_name}"

  tags {
    Name       = "${var.name}-${var.environment}int"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_instance" "oracle" {
  # ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  ami           = "ami-3b288c59"
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
