# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "${var.name}-VPC"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.sub1_cidr_block}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.az_a}"

  tags {
    Name = "${var.name}-public-1"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.sub2_cidr_block}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.az_b}"

  tags {
    Name = "${var.name}-public-2"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.sub3_cidr_block}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.az_a}"

  tags {
    Name = "${var.name}-private-1"
  }
}

resource "aws_subnet" "main-private-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.sub4_cidr_block}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.az_b}"

  tags {
    Name = "${var.name}-private-2"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-IGW"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "${var.all_cidr_block}"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }

  tags {
    Name = "${var.name}-public-route"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = "${aws_subnet.main-public-1.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = "${aws_subnet.main-public-2.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.main-gw"]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.main-public-1.id}"
  depends_on    = ["aws_internet_gateway.main-gw"]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-private-route"
    Created_by = "Terraform"
    script_version = "${var.script_version}"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

# Associate subnet main-private-1 to private route table
resource "aws_route_table_association" "main-private-1_association" {
  subnet_id      = "${aws_subnet.main-private-1.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

# Associate subnet main-private-2 to private route table
resource "aws_route_table_association" "main-private-2_association" {
  subnet_id      = "${aws_subnet.main-private-2.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
