variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

variable "security_group_id" {}
variable "subnet_datacite-private_id" {}
variable "subnet_datacite-alt_id" {}

variable "host" {}
variable "username" {}
variable "password" {}
variable "url_path" {
    default = "/dois/set-url"
}