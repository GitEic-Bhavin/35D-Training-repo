resource "aws_iam_role" "ec2-role" {
  name = "bhavinRoleEc2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "bhavinRoleEc2"
    owner = "bhavin.bhavsar@einfochips.com"
    DM = "Sachin Koshti"
    Department = "PES"
    End_Date = "5 Sep 2024"
  }
}

resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.ec2-role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

output "iam_role_arn" {
  value = aws_iam_role.ec2-role.arn
}