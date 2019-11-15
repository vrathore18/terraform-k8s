resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.name}"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

resource "aws_security_group" "superdrafter_elasticache" {
  name_prefix = "superdrafter-elasticache-"
  vpc_id      = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "superdrafter_elasticache_ingress" {
  security_group_id = "${aws_security_group.superdrafter_elasticache.id}"

  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = "${module.eks.worker_security_group_id}"
}

resource "aws_security_group_rule" "superdrafter_elasticache_egress" {
  security_group_id = "${aws_security_group.superdrafter_elasticache.id}"

  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_elasticache_cluster" "superdrafter" {
  cluster_id           = "${var.name}"
  engine               = "redis"
  node_type            = "${var.elasticcache_instance_type}"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.3"
  subnet_group_name    = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids   = ["${aws_security_group.superdrafter_elasticache.id}"]
}
