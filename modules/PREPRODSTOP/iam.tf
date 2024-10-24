###############################################
resource "aws_iam_role" "ec2_role" {
  name = "${var.instance_name}-ec2-role"

  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_policy" "ec2_management" {
  name        = "${var.instance_name}-aws-iam-policy"
  description = "Policy to allow reading, starting, stopping EC2 instances, and access to specific S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:StartInstances",
        "ec2:DescribeTags",
        "ec2:StopInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:PutObjectAcl",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket}",
        "arn:aws:s3:::${var.s3_bucket}/*" 
       ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "instance_policy" {
  name       = "${var.instance_name}-instance-policy-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_management.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.instance_name}-instance_profile"
  role = aws_iam_role.ec2_role.name
}
