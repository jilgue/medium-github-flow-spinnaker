
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51.0"
    }
  }
}

provider "google" {}

module "gcs_service_account" {
  source = "../../000-modules/service-account"


  account_id   = "gcs-service-account"
  display_name = "Spinnaker GCS service account"
  project      = var.project

  sa_role_binding = ["roles/storage.admin"]
}

resource "local_file" "key_decode" {
  content  = module.gcs_service_account.key_decode
  filename = "${path.module}/../spinnaker/gcs-account.json"
}

resource "google_storage_bucket" "this" {
  name          = "spinnaker"
  storage_class = "REGIONAL"
  location      = "US"
  project       = var.project
  force_destroy = true
}
