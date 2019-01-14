module "allow-ssh" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${var.vpc_id}"
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

module "elb-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${var.vpc_id}"
  name        = "${var.name}-${var.environment}-ELB-SG"
  description = "security group that allows traffic for ELB"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  ingress_cidr_blocks = ["${var.all_cidr_block}"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  tags {
    Name = "${var.name}-${var.environment}-ELB-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

module "app1-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${var.vpc_id}"
  name        = "${var.name}-${var.environment}-App-SG"
  description = "security group that allows traffic for application server"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      description              = "Allow traffic on 22 port from Bastion server"
      rule                     = "ssh-tcp"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 8080 port from Bastion server"
      rule                     = "http-8080-tcp"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 8080 port from ELB"
      rule                     = "http-8080-tcp"
      source_security_group_id = "${module.elb-sg.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 8080 port from self"
      rule                     = "http-8080-tcp"
      source_security_group_id = "${module.app1-sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 4

  tags {
    Name = "${var.name}-${var.environment}-App-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

module "ms-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${var.vpc_id}"
  name        = "${var.name}-${var.environment}-MS-SG"
  description = "security group that allows traffic for oracle tools server"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      description              = "Allow traffic on all port from Bastion server"
      rule                     = "all-all"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
    {
      description              = "Allow traffic on all port from Application server"
      rule                     = "all-all"
      source_security_group_id = "${module.app1-sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 2

  tags {
    Name = "${var.name}-${var.environment}-MS-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

module "oracle-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${var.vpc_id}"
  name        = "${var.name}-${var.environment}-DB-SG"
  description = "security group that allows traffic for oracle tools server"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      description              = "Allow traffic on 1521 port from Bastion server"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 1521 port from Application server"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.app1-sg.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 22 port from Bastion server"
      rule                     = "ssh-tcp"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 1521 port from MS server"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.ms-sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 4

  tags {
    Name = "${var.name}-${var.environment}-DB-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

module "RDS-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = "${var.vpc_id}"
  name        = "${var.name}-${var.environment}-RDS-SG"
  description = "security group that allows traffic for oracle tools server"

  egress_cidr_blocks = ["${var.all_cidr_block}"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      description              = "Allow traffic on 1521 port from Bastion server"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.allow-ssh.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 1521 port from Oracle client"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.oracle-sg.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 1521 port from Application server"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.app1-sg.this_security_group_id}"
    },
    {
      description              = "Allow traffic on 1521 port from MS server"
      rule                     = "oracle-db-tcp"
      source_security_group_id = "${module.ms-sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 4

  tags {
    Name = "${var.name}-${var.environment}-RDS-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_security_group" "efs-sg" {
  name        = "${var.name}-${var.environment}-EFS-SG"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = [
      "${module.app1-sg.this_security_group_id}",
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "${var.vpc_cidr_block}",
    ]
  }

  tags {
    Name = "${var.name}-${var.environment}-EFS-SG"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}
