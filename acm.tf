resource "aws_acm_certificate" "super" {
  domain_name       = "${format("*.%s.%s", var.name, var.route53_genieai_domain)}"
  validation_method = "DNS"
}

resource "aws_route53_record" "super_acm_certificate_validation" {
  name    = "${aws_acm_certificate.super.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.super.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.external_dns.id}"
  records = ["${aws_acm_certificate.super.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "super" {
  certificate_arn         = "${aws_acm_certificate.super.arn}"
  validation_record_fqdns = ["${aws_route53_record.super_acm_certificate_validation.fqdn}"]
}
