# required
variable "target_account_id" {}

variable "backend_config_bucket" {}

variable "backend_config_bucket_region" {}

variable "backend_config_tfstate_file_key" {}

variable "backend_config_role_arn" {}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = "string"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = "string"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = "string"
}

# optional
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
}

variable "eks_instance_type" {
  description = "Instance type to be used to create EKS cluster"
  type        = "string"
  default     = "t3.large"
}

variable "eks_asg_desired_capacity" {
  description = "Number of EC2 Instances within EKS ASG"
  type        = "string"
  default     = "2"
}

variable "eks_asg_max_size" {
  description = "Max number of EC2 Instances within EKS ASG"
  type        = "string"
  default     = "16"
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = "string"
  default     = ""
}

variable "route53_genieai_domain" {
  description = "The domain which clients' subdomains will be created"
  type        = "string"
  default     = "genieai.co"
}

# optional
variable "region" {
  default = "eu-west-1"
}

variable "elasticcache_instance_type" {
  description = "Instance type for Elastic cache"
  type        = "string"
  default     = "cache.m4.large"
}

variable "elasticsearch_host" {
  description = "ELK vpc host"
  type        = "string"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = "string"
  default     = "1.14"
}