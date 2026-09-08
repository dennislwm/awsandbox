variable "name" {
  type = string
}

variable "retention_in_days" {
  type    = number
  default = 365
}

variable "common_tags" {
  type = map(string)
}
