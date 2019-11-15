output "documentdb_host" {
  value = "${aws_docdb_cluster.super.endpoint}"
}

output "documentdb_password" {
  value = "${random_string.documentdb_password.result}"
}

output "elasticache_host" {
  value = "${aws_elasticache_cluster.super.cache_nodes}"
}

output "s3_bucket_documents" {
  value = "${aws_s3_bucket.documents.id}"
}

output "s3_bucket_models" {
  value = "${aws_s3_bucket.models.id}"
}

output "s3_bucket_sdfdocuments" {
  value = "${aws_s3_bucket.sdfdocuments.id}"
}

output "kube2iam_clause_recommendation_role" {
  value = "${aws_iam_role.clause_recommendation.arn}"
}

output "kube2iam_contract_processor_role" {
  value = "${aws_iam_role.contract_processor.arn}"
}

output "kube2iam_graphql_role" {
  value = "${aws_iam_role.graphql.arn}"
}

output "route53_domain" {
  value = "${aws_route53_zone.external_dns.name}"
}

output "route53_domain_nameservers" {
  value = "${aws_route53_zone.external_dns.name_servers}"
}

output "acm_certificate_arn" {
  value = "${aws_acm_certificate.super.arn}"
}
