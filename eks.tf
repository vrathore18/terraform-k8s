module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "6.0.2"

  cluster_name = "${var.name}"
  subnets      = "${module.vpc.private_subnets}"
  vpc_id       = "${module.vpc.vpc_id}"

  kubeconfig_aws_authenticator_additional_args = ["-r", "arn:aws:iam::${var.target_account_id}:role/terraform"]

  worker_groups = [
    {
      instance_type        = "${var.eks_instance_type}"
      asg_desired_capacity = "${var.eks_asg_desired_capacity}"
      asg_max_size         = "${var.eks_asg_max_size}"
      key_name             = "${var.key_name}"
    },
  ]

  # configure aws-iam-authenticator auth;
  #
  # by default only "admin" role from client's AWS account will have
  # access to the cluster (you'll need to assume that role in order 
  # interact with the cluster)
  map_accounts = ["${var.target_account_id}"]

  map_roles = [
    {
      rolearn = "${format("arn:aws:iam::%s:role/admin", var.target_account_id)}"
      username = "${format("%s-admin", var.name)}"
      groups    = ["system:masters"]
    },
  ]

  #map_accounts_count = "1"
  #map_roles_count    = "1"

  # don't write local configs, as we do it anyway
  write_kubeconfig      = "false"
  write_aws_auth_config = "false"
}

resource "local_file" "kubeconfig" {
  content  = "${module.eks.kubeconfig}"
  filename = "./.kube_config.yaml"
}
