resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile = var.aws_iam_instance_profile

  tags = {
    Name = var.instance_name
  }
   lifecycle {
    create_before_destroy = false
  }
}

resource "null_resource" "provision_ec2" {
  triggers = {
    always_run = timestamp()  # Forces re-run on every apply
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y unzip curl",
      "rm -rf aws awscliv2.zip",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "aws --version",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd"
      ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_instance.this.public_ip
    }
  }
}
 
