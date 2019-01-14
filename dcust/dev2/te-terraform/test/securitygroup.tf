module "allow-ssh" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${aws_vpc.main.id}"
  name        = "${var.name}-${var.environment}-Bastion-SG"
  description = "security group that allows ssh and all egress traffic"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      description = "Allow traffic from BLR office"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = "${var.blr_cidr_block}"
    },
  ]

  tags {
    Name = "${var.name}-${var.environment}-Bastion-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}


module "oracle-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${aws_vpc.main.id}"
  name        = "${var.name}-${var.environment}-DB-SG"
  description = "security group that allows traffic for oracle tools server"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      description              = "Allow traffic on 22 port from Bastion server"
      rule                     = "ssh-tcp"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  tags {
    Name = "${var.name}-${var.environment}-DB-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

