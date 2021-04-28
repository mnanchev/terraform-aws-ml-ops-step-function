provider aws {
  region = var.region
}

terraform {
  required_version = "~> 0.12"

  required_providers {
    aws = ">= 3.0"
  }

  backend "s3" {
    bucket  = "ml-ops-prd-eu-central-1-terraform-states"
    key     = "environment/production/infrastructure_as_code.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

