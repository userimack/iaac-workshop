provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "this" {
  key_name   = "spring_petclinic_key"
  public_key = file(var.public_key)
}

