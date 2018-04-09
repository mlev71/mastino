variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "vpc_id" {}

variable "cheetoh_tags" {
  type = "map"
}

variable "lb_name" {
  default = "lb-stage"
}

variable "ttl" {
  default = "300"
}

variable "memcache_servers" {
  default = "memcached.test.datacite.org:11211"
}

variable "secret_key_base" {}
variable "librato_email" {}
variable "librato_token" {}
variable "bugsnag_key" {}

variable "librato_suites" {
  default = "rails_controller,rails_status,rails_cache,rails_job,rails_sql,rack"
}