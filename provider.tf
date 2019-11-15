provider "aws" {
  region  = "${var.region}"
  version = "~> 2.0"

  assume_role {
    role_arn = "arn:aws:iam::${var.target_account_id}:role/terraform"
  }
}

provider "kubernetes" {
  config_path = ".kube_config.yaml"
  version = "~> 1.9"
}

provider "helm" {
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"


  kubernetes {
    config_path = ".kube_config.yaml"
  }
}

terraform {
  backend "s3" {
    
  }
}

data "terraform_remote_state" "state" {
  backend = "s3"
  config = {
    bucket         = "${var.backend_config_bucket}"
    region         = "${var.backend_config_bucket_region}"
    key            = "${var.name}/${var.backend_config_tfstate_file_key}" # var.name == CLIENT
    role_arn       = "${var.backend_config_role_arn}"
    skip_region_validation = true
    dynamodb_table = "terraform_locks"
    encrypt        = "true"
  }
}
