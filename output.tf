output "instance_id" {
  value = module.ec2_instance.instance_id
}
output "instance_public_ip" {
  value = module.ec2_instance.instance_public_ip
}

output "instance_profile_name" {
  value = module.ec2_s3_role.instance_profile_name
}
output "security_group_id" {
  description = "ID of the security group"
  value       = module.web_sg.security_group_id
}
output "instance_name" {
  value = var.instance_name
}