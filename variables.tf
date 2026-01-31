variable "aws_region" {
  type    = string
  default = "us-west-2" 
  
}

variable "vpc_id" {
  type = string
  default = "vpc-09c149167d5e10584"
}

variable "subnet_id" {
  type = string
  default = "subnet-0388da279717950f9"
}

variable "key_pair_name" {
  type = string
  default = "my-key-pair"
}

variable "aws_iam_user" {
  type = string
  default = "loadbalancer"
}
 variable "aws_iam_policy_name" {
  type = string
  default = "loadbalancer-policy"
 }
 
variable "ec2_1_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_1_disk_size" {
  type    = number
  default = 30
}

variable "ec2_2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_2_disk_size" {
  type    = number
  default = 60
}

variable "ec2_3_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_3_disk_size" {
  type    = number
  default = 120
}

# S3 Bucket Name
variable "s3_bucket_name" {
  type = string
  default = "test-hdjsdhsahds13232"
} 
# S3 Bucket Environment Tag
variable "s3_environment" {
  type    = string
  default = "dev"
}