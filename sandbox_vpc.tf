resource "aws_vpc" "domain" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "awsandbox-vpc-${local.project_name}-${var.environment}" }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.domain.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags = { Name = "awsandbox-subnet-a-${local.project_name}-${var.environment}-01" }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.domain.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  tags = { Name = "awsandbox-subnet-a-${local.project_name}-${var.environment}-02" }
}

resource "aws_security_group" "domain" {
  name   = "awsandbox-sg-${local.project_name}-${var.environment}-domain"
  vpc_id = aws_vpc.domain.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "domain" {
  name = "awsandbox-iamrole-${local.project_name}-${var.environment}-default-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "sagemaker.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}
