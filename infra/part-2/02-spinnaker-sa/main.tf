
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }
  }
}

data "terraform_remote_state" "gke" {
  backend = "local"

  config = {
    path = "../01-gke/terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_${var.project}_${data.terraform_remote_state.gke.outputs.gke_zone}_${data.terraform_remote_state.gke.outputs.gke_name}"
}

resource "kubernetes_namespace" "this" {
  for_each = zipmap(var.environments, var.environments)
  metadata {
    name = each.value
  }
}

resource "kubernetes_service_account" "this" {
  for_each = zipmap(var.environments, var.environments)

  metadata {
    name = "spinnaker-service-account"
    namespace = each.value
  }

  depends_on = [kubernetes_namespace.this]
}