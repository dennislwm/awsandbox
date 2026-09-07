variable "tags" {
  type    = map(string)
  default = {}
}

variable "project_name" {
  type    = string
  default = "sandbox"
}

variable "environment" {
  type = string
}
