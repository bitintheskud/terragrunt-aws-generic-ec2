// If eip is enable we use the eip public dns. else we use the aws ephemeral dns name.
resource "aws_route53_record" "public_dns" {
  count   = var.enable_route53 ? "${var.enable_ec2_public_ip ? 1 : 0}" : 0
  name    = local.name_identifier
  type    = "CNAME"
  ttl     = 300
  zone_id = var.route53_zone_id
  records = module.ec2_cluster.public_dns
}
