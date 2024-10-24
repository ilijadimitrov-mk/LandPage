variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "AWS region to deploy resources"
  type        = string
}

#variable "instance_name" {
#  description = "Name of the EC2 instance"
#  type        = string
#}

#variable "ami_id" {
#  description = "AMI ID for the EC2 instance"
#  type        = string
#}

#variable "instance_type" {
#  description = "EC2 instance type"
#  type        = string
#}

variable "vpc_id" {
  description = "VPC ID where the instance will be deployed"
  type        = string
}

#variable "subnet_id" {
#  description = "Subnet ID for the instance"
#  type        = string
#}

variable "subnet1_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "subnet2_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "subnet3_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "subnet1" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "subnet2" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "subnet3" {
  description = "Subnet ID for the instance"
  type        = string
}

#variable "s3_bucket" {
#  description = "S3 bucket for the instance"
#  type        = string
#}

#variable "security_groups" {
#  description = "Security groups for the EC2 instance"
#  type        = list(string)
#}

#variable "keypair" {
#  description = "Key Pair Name"
#  type        = string
#}

#variable "ad_sg_id" {
#  description = "AD SG ID"
#  type        = string
#}

#variable "alb_sg_id" {
#  description = "ALB SG ID"
#  type        = string
#}

