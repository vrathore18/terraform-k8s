resource "helm_release" "external-dns" {
  name       = "external-dns"
  depends_on = ["module.eks"]

  namespace = "kube-system"
  chart     = "${path.module}/charts/external-dns"

  lifecycle {
        ignore_changes = [
            "chart"
        ]
    }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "podAnnotations.iam\\.amazonaws\\.com\\/role"
    value = "${aws_iam_role.external_dns.arn}"
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }
}

resource "aws_route53_zone" "external_dns" {
  name = "${format("%s.%s", var.name, var.route53_genieai_domain)}"
}

resource "aws_iam_role" "external_dns" {
  name_prefix        = "external-dns_"
  assume_role_policy = "${data.aws_iam_policy_document.external_dns_trust_policy.json}"
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.external_dns.zone_id}",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "external_dns_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${module.eks.worker_iam_role_arn}"]
    }
  }
}

resource "aws_iam_policy" "external_dns" {
  name_prefix = "external_dns_"
  policy      = "${data.aws_iam_policy_document.external_dns.json}"
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = "${aws_iam_role.external_dns.name}"
  policy_arn = "${aws_iam_policy.external_dns.arn}"
}
