variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "create_access_entry" {
  description = "Whether to create the access entry"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}