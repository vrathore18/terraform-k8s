module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = "${var.name}"
  cidr = "${var.vpc_cidr}"

  #azs             = ["${split(",", var.azs)}"]
  #private_subnets = ["${split(",", var.private_subnets)}"]
  #public_subnets  = ["${split(",", var.public_subnets)}"]
  azs             = ["${var.azs}"]
  private_subnets = ["${var.private_subnets}"]
  public_subnets  = ["${var.public_subnets}"]

  enable_nat_gateway = "${var.enable_nat_gateway}"
  single_nat_gateway = "${var.single_nat_gateway}"

  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = "${merge(
    map(format("kubernetes.io/cluster/%s", var.name), "shared"),
    map("Terraform", "true")
  )}"

  public_subnet_tags = "${merge(
    map("kubernetes.io/role/elb", "1"),
    map("type", "public")
  )}"

  private_subnet_tags = "${merge(
    map(format("kubernetes.io/cluster/%s", var.name), "shared"),
    map("kubernetes.io/role/internal-elb", "1"),
    map("type", "private")
  )}"
}
