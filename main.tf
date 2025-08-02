terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region

}

data "aws_vpc" "default" {
  default = true
}
module "ec2_instance" {
  source        = "./modules/ec2"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  instance_name = var.instance_name
  key_name      = var.key_name
  vpc_id       = data.aws_vpc.default.id
  private_key_path = var.private_key_path
  security_group_ids = [module.web_sg.security_group_id]
  aws_iam_instance_profile  = module.ec2_s3_role.instance_profile_name
}
module "web_sg" {
  source      = "./modules/security_groups"
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["49.207.209.216/32"]  # Replace with your IP address
    }
  ]

  tags = {
    Environment = "dev"
    Name        = "web-sg"
  }
}


module "ec2_s3_role" {
  source      = "./modules/iam_role_ec2"
  role_name   = "ec2-access-my-s3-bucket"
  bucket_name = "my-special-bucket-name"
}
