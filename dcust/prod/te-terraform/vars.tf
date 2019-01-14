variable "AWS_REGION" {
  type        = "string"
  description = "Specify AWS region for infrastructure"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "PATH_TO_PRIVATE_KEY" {
  default = "brixon"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "brixon.pub"
}

variable "blr_cidr_block" {
  type        = "string"
  description = "the cidr block for BLR office"
}

variable "environment" {
  type        = "string"
  default     = "abc"
  description = "Environment such as Prod, Dev, Test"
}

variable "name" {
  type        = "string"
  default     = "xyz"
  description = "Name of customer ex. Gymboree"
}

variable "script_version" {
  type        = "string"
  default     = "pqr"
  description = "version of script"
}

variable "all_cidr_block" {
  type        = "string"
  description = "the cidr block for everywhere"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "the cidr block for vpc"
}

variable "sub1_cidr_block" {
  type        = "string"
  description = "the cidr block for first subnet"
}

variable "sub2_cidr_block" {
  type        = "string"
  description = "the cidr block for second subnet"
}

variable "sub3_cidr_block" {
  type        = "string"
  description = "the cidr block for third subnet"
}

variable "ssl_arn" {
  type        = "string"
  description = "ssl for ALB"
}

variable "sub4_cidr_block" {
  type        = "string"
  description = "the cidr block for fourth subnet"
}

variable "az_a" {
  type        = "string"
  description = "Availablitity zone 1a"
}

variable "az_b" {
  type        = "string"
  description = "Availablitity zone 1b"
}

variable "AMIS" {
  type = "map"

  default = {
    us-east-1      = "ami-13be557e"
    us-west-2      = "ami-06b94666"
    eu-west-1      = "ami-466768ac"
    ap-south-1     = "ami-76d6f519"
    ap-southeast-2 = "ami-39f8215b"
  }
}

//variable "azs" {
//  type = "string"

//  default = "eu-west-1a, eu-west-1b"

//  description = "Availablitity zones"
//}

variable "azs" {
  type = "map"

  default = {
    ap-southeast-2 = "ap-southeast-2a,ap-southeast-2b"
  }
}
variable "vpc_id" {
  type        = "string"
  description = "Get VPC ID from AWS console"
}
variable "alb_arn" {
  type        = "string"
  description = "Get ALB arn"
}
variable "private_key" {
  type        = "string"
  description = "Private key for customer"
}
variable "sub_app" {
  type       = "string"
  description = "Application subnet id"
}
variable "sub_int" {
  type       = "string"
  description = "Integration subnet id"
}
variable "listener_arn" {
  type       = "string"
  description = "Integration subnet id"
}


