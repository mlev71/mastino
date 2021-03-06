variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "vpc_id" {}

variable "volpino_tags" {
  type = "map"
}

variable "lb_name" {
  default = "lb-stage"
}

variable "ttl" {
  default = "300"
}

variable "solr_url" {
  default = "https://solr.test.datacite.org/api"
}
variable "search_url" {
  default = "https://search.test.datacite.org"
}
variable "orcid_url" {
  default = "https://sandbox.orcid.org"
}
variable "orcid_api_url" {
  default = "https://api.sandbox.orcid.org"
}
variable "bracco_url" {
  default = "https://doi.test.datacite.org"
}
variable "app_url" {
  default = "https://app.test.datacite.org"
}
variable "cdn_url" {
  default = "https://assets.test.datacite.org"
}
variable "blog_url" {
  default = "https://blog.test.datacite.org"
}

variable "redis_url" {}
variable "memcache_servers" {
  default = "memcached.test.datacite.org:11211"
}

variable "jwt_public_key" {}
variable "jwt_private_key" {}
variable "bugsnag_key" {}
variable "bugsnag_js_key" {}
variable "orcid_update_uuid" {}
variable "orcid_token" {}
variable "notification_access_token" {}
variable "secret_key_base" {}
variable "github_personal_access_token" {}

variable "mysql_user" {}
variable "mysql_password" {}
variable "mysql_database" {
  default = "profiles"
}
variable "mysql_host" {}

variable "orcid_client_id" {}
variable "orcid_client_secret" {}
variable "github_client_id" {}
variable "github_client_secret" {}
variable "google_client_id" {}
variable "google_client_secret" {}
