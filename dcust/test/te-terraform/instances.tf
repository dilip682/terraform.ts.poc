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
  subnet_id = "${var.sub_app}"
  user_data = "${data.template_file.user_data1.rendered}"

  # the security group
  vpc_security_group_ids = ["${module.app1-sg.this_security_group_id}"]

  root_block_device {
    volume_size = "8"
  }

  # the public SSH keyel
  key_name = "${var.private_key}"

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
  subnet_id = "${var.sub_int}"
  user_data = "${data.template_file.user_data1.rendered}"

  # the security group
  vpc_security_group_ids = ["${module.app1-sg.this_security_group_id}"]

  root_block_device {
    volume_size = "20"
  }

  # the public SSH keyel
  key_name = "${var.private_key}"

  tags {
    Name       = "${var.name}-${var.environment}int"
    Lifecycle  = "${var.environment}"
    Customer   = "${var.name}"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

