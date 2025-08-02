resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = file("${path.module}/user_data.sh")
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
 /* provisioner "local-exec" {
  command = <<EOT
    mkdir -p $HOME/.ssh
    ssh-keyscan -H ${aws_instance.this.public_ip} >> $HOME/.ssh/known_hosts
  EOT
  interpreter = ["bash", "-c"]
}*/

   provisioner "file" {
    source      = "site/"                      # 👈 Your local file
    destination = "/home/ec2-user/"       # 👈 Remote path

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_instance.this.public_ip

      
    }
  }



  provisioner "remote-exec" {
    inline = [

      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo rm -rf /var/www/html/*",
      "sudo mv /home/ec2-user/site/* /var/www/html/"

      ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_instance.this.public_ip
    }
  }
 
}
 
