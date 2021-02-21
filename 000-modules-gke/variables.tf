variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type    = string
  default = ""
}

variable "name" {
  type = string
}

variable "node_pool_machine_type" {
  type    = string
  default = "e2-medium"
}

variable "subnet_cidr_prefix" {
  type = string
}

variable "regional" {
  type    = bool
  default = true
}
