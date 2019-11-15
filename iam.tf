resource "aws_iam_role" "clause_recommendation" {
  name_prefix        = "clause-recommendation-"
  assume_role_policy = "${data.aws_iam_policy_document.clause_recommendation_trust_policy.json}"
}

resource "aws_iam_policy" "clause_recommendation" {
  name_prefix = "clause-recommendation-"
  policy      = "${data.aws_iam_policy_document.clause_recommendation.json}"
}

resource "aws_iam_role_policy_attachment" "clause_recommendation" {
  role       = "${aws_iam_role.clause_recommendation.name}"
  policy_arn = "${aws_iam_policy.clause_recommendation.arn}"
}

data "aws_iam_policy_document" "clause_recommendation" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.models.arn}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.models.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "clause_recommendation_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${module.eks.worker_iam_role_arn}"]
    }
  }
}

resource "aws_iam_role" "contract_processor" {
  name_prefix        = "contract-processor-"
  assume_role_policy = "${data.aws_iam_policy_document.contract_processor_trust_policy.json}"
}

resource "aws_iam_policy" "contract_processor" {
  name_prefix = "contract-processor-"
  policy      = "${data.aws_iam_policy_document.contract_processor.json}"
}

resource "aws_iam_role_policy_attachment" "contract_processor" {
  role       = "${aws_iam_role.contract_processor.name}"
  policy_arn = "${aws_iam_policy.contract_processor.arn}"
}

data "aws_iam_policy_document" "contract_processor" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.documents.arn}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.documents.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "contract_processor_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${module.eks.worker_iam_role_arn}"]
    }
  }
}

resource "aws_iam_role" "graphql" {
  name_prefix        = "graphql-"
  assume_role_policy = "${data.aws_iam_policy_document.graphql_trust_policy.json}"
}

resource "aws_iam_policy" "graphql" {
  name_prefix = "graphql-"
  policy      = "${data.aws_iam_policy_document.graphql.json}"
}

resource "aws_iam_role_policy_attachment" "graphql" {
  role       = "${aws_iam_role.graphql.name}"
  policy_arn = "${aws_iam_policy.graphql.arn}"
}

data "aws_iam_policy_document" "graphql" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.sdfdocuments.arn}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.sdfdocuments.arn}/*",
    ]
  }

  statement {
    actions = [
        "SES:SendEmail",
        "SES:SendRawEmail" 
#    ],
    ]
    resources = ["*"]

    condition {
      test = "StringEquals"
			variable = "ses:FromAddress"
			values = ["support@genieai.co"]
    }
  }
}

data "aws_iam_policy_document" "graphql_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${module.eks.worker_iam_role_arn}"]
    }
  }
}
