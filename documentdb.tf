resource "aws_docdb_subnet_group" "default" {
  name       = "${var.name}"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

resource "aws_security_group" "superdrafter_documentdb" {
  name_prefix = "superdrafter-documentdb"
  vpc_id      = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "superdrafter_documentdb_ingress" {
  security_group_id = "${aws_security_group.superdrafter_documentdb.id}"

  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = "${module.eks.worker_security_group_id}"
}

resource "aws_security_group_rule" "superdrafter_documentdb_egress" {
  security_group_id = "${aws_security_group.superdrafter_documentdb.id}"

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_docdb_cluster" "superdrafter" {
  cluster_identifier_prefix = "${var.name}-"
  engine                    = "docdb"
  master_username           = "superdrafter"
  master_password           = "${random_string.documentdb_password.result}"
  backup_retention_period   = 7
  preferred_backup_window   = "03:00-05:00"
  skip_final_snapshot       = true
  storage_encrypted         = true
  db_subnet_group_name      = "${aws_docdb_subnet_group.default.name}"
  vpc_security_group_ids    = ["${aws_security_group.superdrafter_documentdb.id}"]
}

resource "aws_docdb_cluster_instance" "docdb" {
  count              = 1
  identifier         = "docdb-cluster-${var.name}-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.superdrafter.id}"
  instance_class     = "db.r4.large"
}
