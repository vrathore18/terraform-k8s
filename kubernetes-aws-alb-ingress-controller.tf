resource "helm_release" "aws-alb-ingress-controller" {
  name       = "aws-alb-ingress-controller"
  depends_on = ["module.eks"]

  namespace = "kube-system"
  chart     = "${path.module}/charts/aws-alb-ingress-controller"

  lifecycle {
        ignore_changes = [
            "chart"
        ]
    }

  #depends_on = ["helm_release.kube2iam"]

  set {
    name  = "clusterName"
    value = "${module.eks.cluster_id}"
  }

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }

  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }

  set {
    name  = "podAnnotations.iam\\.amazonaws\\.com\\/role"
    value = "${aws_iam_role.aws_alb_ingress_controller.arn}"
  }
}

# aws-alb-ingress-controller role, as per documentation
resource "aws_iam_role" "aws_alb_ingress_controller" {
  name_prefix        = "k8s-app-alb-ingress-controller-"
  assume_role_policy = "${data.aws_iam_policy_document.aws_alb_ingress_controller_trust_policy.json}"
}

resource "aws_iam_policy" "aws_alb_ingress_controller" {
  name_prefix = "aws-alb-ingress-controller-"
  policy      = "${data.aws_iam_policy_document.aws_alb_ingress_controller.json}"
}

resource "aws_iam_role_policy_attachment" "aws_alb_ingress_controller" {
  role       = "${aws_iam_role.aws_alb_ingress_controller.name}"
  policy_arn = "${aws_iam_policy.aws_alb_ingress_controller.arn}"
}

data "aws_iam_policy_document" "aws_alb_ingress_controller" {
  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "tag:GetResources",
      "tag:TagResources",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "waf:GetWebACL",
    ]

    resources = [
      "*",
    ]
  }
}

# create default role which all pods will be assigned
data "aws_iam_policy_document" "aws_alb_ingress_controller_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${module.eks.worker_iam_role_arn}"]
    }
  }
}
