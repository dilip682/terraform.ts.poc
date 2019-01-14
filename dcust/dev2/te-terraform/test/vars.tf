variable "AWS_REGION" {
  type        = "string"
  description = "Specify AWS region for infrastructure"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "PATH_TO_PRIVATE_KEY" {
  default = "management" 
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "management.pub"
}
variable "bastion"{
  type = "string"
  description = "Define bastion AMI here"
}

variable "oracle"{
  type = "string"
  description = "Define oracle AMI here"
}


variable "blr_cidr_block" {
  type        = "string"
  description = "the cidr block for BLR office"
}

variable "name" {
  type        = "string"
  default     = "management"
  description = "Name of customer ex. Gymboree"
}
variable "environment" {
  type        = "string"
  default     = "BR"
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

