#!/bin/bash
sudo yum update -y
sudo yum install -y unzip curl

rm -rf aws awscliv2.zip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
rm -rf awscliv2.zip
sudo ./aws/install
aws --version
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir -p /home/ec2-user/site



