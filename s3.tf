resource "aws_s3_bucket" "documents" {
  bucket_prefix = "${format("%s-documents-", var.name)}"
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "models" {
  bucket_prefix = "${format("%s-models-", var.name)}"
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "sdfdocuments" {
  bucket_prefix = "${format("%s-sdfdocuments-", var.name)}"
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
