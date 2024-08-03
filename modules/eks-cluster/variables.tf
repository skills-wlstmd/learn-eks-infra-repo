
variable "cluster_name" {
}
variable "cluster_version" {
}
variable "vpc_id" {
}
variable "public_subnets" {
}
variable "private_subnets" {
}
variable "create_access_entry" {
  description = "Whether to create the access entry"
  type        = bool
  default     = false
}