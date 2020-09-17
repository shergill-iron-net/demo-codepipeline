terraform {
  backend "s3" {
    bucket = "ironnet-terraform-state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
