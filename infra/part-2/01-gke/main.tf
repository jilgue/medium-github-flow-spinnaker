
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51.0"
    }
  }
}

provider "google" {}

variable "name" {
  type = string
  default = "environments"
}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
  status  = "UP"
}

module "environments" {
  source = "../../000-modules/gke"

  name               = var.name
  project            = var.project
  region             = var.region
  regional           = false
  zone               = data.google_compute_zones.available.names[0]
  subnet_cidr_prefix = "10.1.0.0/22"
}

output "gke_service_account" {
  value = module.environments.gke_service_account
}

output "gke_name" {
  value = var.name
}

output "gke_zone" {
  value = data.google_compute_zones.available.names[0]
}