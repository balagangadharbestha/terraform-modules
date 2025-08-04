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
      cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP address
    }
  ]

  tags = {
    Environment = "dev"
    Name        = "web-sg"
  }
}

/*module "my_s3_bucket" {
  source            = "./modules/s3_bucket"
  bucket_name       = "balu-unique-bucket-082025"  # make sure this is globally unique
  acl               = "private"
  versioning_enabled = true
  tags = {
    Environment = "Dev"
    Project     = "Terraform S3 Module"
  }
}
*/

terraform {
  backend "s3" {
    bucket         = "balu-unique-bucket-0741"     # your unique S3 bucket
    key            = "env/dev/terraform.tfstate"       # state file path within bucket
    region         = "us-east-1"                       # S3 bucket region
    encrypt        = true                              # encrypt state file
   # dynamodb_table = "terraform-locks"                 # optional: for locking
  }
}


module "ec2_s3_role" {
  source      = "./modules/iam_role_ec2"
  role_name   = "ec2-access-my-s3-bucket"
  bucket_name = "*balu-unique-bucket-0741"  # your unique S3 bucket
}
