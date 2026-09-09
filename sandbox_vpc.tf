resource "aws_vpc" "domain" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(var.common_tags, { Name = "${var.owner}-vpc-${local.project_name}-${var.environment}" })
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.domain.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = merge(var.common_tags, { Name = "${var.owner}-subnet-a-${local.project_name}-${var.environment}-01" })
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.domain.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  tags              = merge(var.common_tags, { Name = "${var.owner}-subnet-a-${local.project_name}-${var.environment}-02" })
}

resource "aws_security_group" "domain" {
  name   = "${var.owner}-sg-${local.project_name}-${var.environment}-domain"
  vpc_id = aws_vpc.domain.id
  tags   = var.common_tags
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "domain" {
  name = "${var.owner}-iamrole-${local.project_name}-${var.environment}-default-exec"
  tags = var.common_tags
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "sagemaker.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}
