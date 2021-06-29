data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "crdbnode-role" {
  name                = "crdbnode-role"
  assume_role_policy  = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"]
}

resource "aws_iam_instance_profile" "crdbnode-profile" {
  name = "crdbnode-profile"
  role = aws_iam_role.crdbnode-role.name
}
