output "ec2_private_dns" {
  value = "${module.ec2_cluster.private_dns}"
}

output "ec2_private_ip" {
  value = "${module.ec2_cluster.private_ip}"
}

output "ec2_public_dns" {
  value = "${module.ec2_cluster.public_dns}"
}

output "ec2_public_ip" {
  value = module.ec2_cluster.*.public_ip
}

output "ec2_eip_public_ip" {
  value = aws_eip.eip.*.public_ip
}

output "dns_public_ip" {
  value = aws_route53_record.public_dns.*.name
}

output "instance_ids" {
  value       = module.ec2_cluster.id
  description = "EC2 instance id as a list"
}

output "security_group_id" {
  value       = aws_security_group.security_group.id
  description = "Security Group id attach to the instance(s)"
}

output "availability_zone" {
  value       = module.ec2_cluster.availability_zone
  description = "EC2 availability_zone as a list"
}

output "instance_count" {
  value = var.ec2_instance_count
  description = "EC2 instance count"
}
