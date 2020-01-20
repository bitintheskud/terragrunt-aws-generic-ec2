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

output "security_group_id" {
  value       = aws_security_group.security_group.id
  description = "Security Group id attach to the instance(s)"
}
