variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default = "vpc-0bb1c1f2example"
}

variable "subnet_id" {
  description = "Existing Subnet ID"
  type        = string
  default     = "subnet-0bb1c1f2example"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 3
}

variable "key_pair_name" {
  description = "Existing AWS key pair name"
  type        = string
  default = "my-existing-keypair"
}
variable "volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 30

}