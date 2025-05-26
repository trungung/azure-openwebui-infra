
variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "resource_group_name" {
  type    = string
  default = "rg-openwebui"
}

variable "storage_account_name" {
  type    = string
  default = "stopenwebui"
}

variable "file_share_name" {
  type    = string
  default = "openwebui-data"
}

variable "container_app_env_name" {
  type    = string
  default = "cae-openwebui"
}

variable "container_app_name" {
  type    = string
  default = "ca-openwebui"
}

variable "container_image" {
  type    = string
  default = "ghcr.io/open-webui/open-webui:main"
}

variable "target_port" {
  type    = number
  default = 8080
}
