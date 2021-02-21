
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
  source = "../../000-modules-gke"

  name               = "spinnaker"
  project            = var.project
  region             = var.region
  subnet_cidr_prefix = "10.1.0.0/21"
}

module "environment1" {
  source = "../../000-modules-gke"

  name               = "environment1"
  project            = var.project
  region             = var.region
  regional           = false
  zone               = "europe-west1-b"
  subnet_cidr_prefix = "10.2.0.0/22"
}
