variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0cbbe2c6a1bb2ad63" # Amazon Linux 2 (change per region)
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "MyEC2FromModule"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
  default     = "terraform-us-east-1" # Adjust as necessary
}

variable "private_key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
}