variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "vpc_id" {}

variable "content-negotiation_tags" {
  type = "map"
}

variable "lb_name" {
  default = "lb-stage"
}

variable "security_group_id" {}

variable "ttl" {
  default = "300"
}

variable "subnet_datacite-private_id" {}
variable "subnet_datacite-alt_id" {}

variable "search_url" {
  default = "https://search.test.datacite.org/"
}
variable "citeproc_url" {
  default = "https://citation.crosscite.org/format"
}

variable "memcache_servers" {
  default = "memcached.test.datacite.org:11211"
}

variable "bugsnag_key" {}
variable "ssh_public_key" {}