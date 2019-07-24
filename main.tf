# Using the AWS Provider
provider "aws" {
  version = "~> 2.19"
  region     = "${var.region}"
} # end provider

