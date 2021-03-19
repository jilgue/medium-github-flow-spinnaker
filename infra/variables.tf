variable "project" {
  type    = string
  default = "callepuzzle-lab"
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "environments" {
  type = list(string)
  default = ["dev", "pro"]
}
