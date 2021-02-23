
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51.0"
    }
  }
}

provider "google" {}

module "spinnaker" {
  source = "../../000-modules/gke"

  name               = "spinnaker"
  project            = var.project
  region             = var.region
  subnet_cidr_prefix = "10.1.0.0/21"
}
