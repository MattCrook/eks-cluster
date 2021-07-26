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



############################################################
# For built dev account
// data "aws_ami" "eks-worker" {
//   most_recent = true

//   filter {
//     name   = "name"
//     values = ["${var.ami_name}"]
//   }

//   # us-east-1 x86 optimized-ami/1.20/amazon-linux-2
# List of AMI owners to limit search. At least 1 value must be specified. Valid values: an AWS account ID, self (the current account),
# or an AWS owner alias (e.g. amazon, aws-marketplace, etc...)
# Use the dev-developer account ID or self
//   owners      = ["0260be01d66417f7f"]
// }


# For personal account - testing purposes
// data "aws_ami" "eks-worker" {
//   most_recent      = true
//   owners           = ["0eeeef929db40543c"]

//   filter {
//     name   = "name"
//     values = ["${var.ami_name}"]
//   }

//   filter {
//     name   = "virtualization-type"
//     values = ["hvm"]
//   }
// }
