terraform {
  required_version = ">=1.0.0"

  backend "s3" {
    bucket         = "dev-remote-backend-bucket"
    key            = "eu-central-1/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dev-RemoteBackendTable"
    encrypt        = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}