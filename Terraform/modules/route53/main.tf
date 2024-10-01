resource "aws_route53_zone" "primary" {
  name = var.domain_name
}


resource "aws_route53_record" "env" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.subdomain_name
  type    = "A"
  
  alias {
    name                   = var.s3_web_domain
    zone_id                = var.s3_web_hosted_zone
    evaluate_target_health = false
  }
}

