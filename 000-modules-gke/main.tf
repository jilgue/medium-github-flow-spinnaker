locals {
  subnet_ranges = cidrsubnets(var.subnet_cidr_prefix, 2, 2, 2)
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.1.0"

  project_id   = var.project
  network_name = var.name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "${var.name}-${var.region}"
      subnet_ip     = local.subnet_ranges[0]
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.name}-${var.region}" = [
      {
        range_name    = "${var.name}-${var.region}-services"
        ip_cidr_range = local.subnet_ranges[1]
      },
      {
        range_name    = "${var.name}-${var.region}-pod"
        ip_cidr_range = local.subnet_ranges[2]
      },
    ]
  }

  routes = [
    {
      name              = "${var.name}-egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
  status  = "UP"
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 13.0.0"

  project_id = var.project
  name       = var.name
  regional   = var.regional
  region     = var.region
  zones      = var.regional == true ? data.google_compute_zones.available.names : [var.zone]

  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets["${var.region}/${module.vpc.network_name}-${var.region}"].name
  ip_range_services          = module.vpc.subnets["${var.region}/${module.vpc.network_name}-${var.region}"].secondary_ip_range[0].range_name
  ip_range_pods              = module.vpc.subnets["${var.region}/${module.vpc.network_name}-${var.region}"].secondary_ip_range[1].range_name
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true
  remove_default_node_pool   = true
  default_max_pods_per_node  = 50

  node_pools = [
    {
      name         = "pool-01"
      machine_type = var.node_pool_machine_type
      node_count   = 1
      auto_upgrade = true
      auto_repair  = true
      autoscaling  = false
    }
  ]
}
