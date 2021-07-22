data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# For assuming Federated User through an Identity provider
data "aws_iam_policy_document" "service_account_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }

  most_recent = true
  # us-east-1 x86 optimized-ami/1.20/amazon-linux-2
  owners      = ["0260be01d66417f7f"]
}
