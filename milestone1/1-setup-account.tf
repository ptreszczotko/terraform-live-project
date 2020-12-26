terraform {
  required_providers {
    aws = ">= 3.20.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
  path = "/somePath/"
}

resource "aws_iam_access_key" "keys" {
  user = aws_iam_user.terraform.name
}

data "aws_iam_policy" "AmazonEC2FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "TerraformUser_AmazonEC2FullAccess" {
  user       = aws_iam_user.terraform.name
  policy_arn = data.aws_iam_policy.AmazonEC2FullAccess.arn
}

data "aws_ami" "linux2_hvm" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "just-a-name" {
    ami = data.aws_ami.linux2_hvm.id
    instance_type = "t2.micro"
}