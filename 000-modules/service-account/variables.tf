variable "project" {
  type = string
}

variable "account_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "sa_role_binding" {
  type = list(string)
  default = []
}
