locals {
  comprehend_policy_name = format("%s-iampolicy-%s-%s-%s", var.owner, var.project_name, var.environment, "comprehend")
}

resource "aws_iam_role_policy" "comprehend" {
  name = local.comprehend_policy_name
  role = data.aws_iam_role.domain_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["comprehend:DetectSentiment", "comprehend:DetectEntities"]
        Resource = "*"
        Condition = {
          "ForAllValues:StringEquals" = {
            "comprehend:VpcSubnets" = [
              data.aws_subnet.sagemaker_subnet_a.id,
              data.aws_subnet.sagemaker_subnet_b.id,
            ]
            "comprehend:VpcSecurityGroupIds" = [
              data.aws_security_group.domain_security_group.id,
            ]
          }
          Null = {
            "comprehend:VpcSubnets"          = "false"
            "comprehend:VpcSecurityGroupIds" = "false"
          }
        }
      }
    ]
  })
}
