###############
# EKS Cluster
###############
resource "aws_iam_role" "cluster" {
  name = "${var.master_role_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.cluster.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.cluster.name}"
}

###############
# EKS Node
###############
resource "aws_iam_role" "node" {
  name = "${var.worker_role_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.node.name}"
}



#######################
# Cloudwatch / Logging
######################
resource "aws_iam_policy" "CloudWatchLogs" {
    name        = "kubernetes"
    description = "Kubernetes node policy to allow writing logs"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.kubernetes.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "logs:DescribeLogGroups"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${var.account_id}:log-group::log-stream:"
            ]
        }
    ]
}
EOF
}

# Originally under Resource: Todo: dynamically add account_id
# Outputs > vars or module for dynamic adding
# "arn:aws:logs:${var.region}:${var.account_id}:log-group::log-stream:"
# "arn:aws:logs:${var.region}:${aws_iam_role.node.unique_id}:log-group::log-stream:"


resource "aws_iam_role_policy_attachment" "CloudWatchLogs" {
    role       = "${aws_iam_role.node.name}"
    policy_arn = "${aws_iam_policy.CloudWatchLogs.arn}"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.worker_role_name}"
  role = "${aws_iam_role.node.name}"
}

# Optionally, enable Security Groups for Pods
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}


#############################################


// resource "aws_iam_role" "node_group" {
//   name = "${var.worker_role_name}"

//   assume_role_policy = jsonencode({
//     Statement = [{
//       Action = "sts:AssumeRole"
//       Effect = "Allow"
//       Principal = {
//         Service = "ec2.amazonaws.com"
//       }
//     }]
//     Version = "2012-10-17"
//   })
// }

// resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
//   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
//   role       = aws_iam_role.node_group.name
// }

// resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
//   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
//   role       = aws_iam_role.node_group.name
// }

// resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
//   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
//   role       = aws_iam_role.node_group.name
// }


// resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
//   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
//   role       = "${aws_iam_role.node_group.name}"
// }

// resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
//   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
//   role       = "${aws_iam_role.node_group.name}"
// }
