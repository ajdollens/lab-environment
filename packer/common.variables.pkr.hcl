variable "project_id" {
  type        = string
  description = "GCP project to build images in"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "network" {
  type    = string
  default = "default"
}

variable "subnetwork" {
  type    = string
  default = ""
}

variable "source_image_family" {
  type    = string
  default = "ubuntu-2404-lts-amd64"
}

variable "git_sha" {
  type        = string
  default     = "local"
  description = "Commit the image was built from, set by CI"
}

locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())

  # GCP label values: lowercase letters, digits, - and _, max 63 chars
  common_labels = {
    built_by = "packer"
    git_sha  = var.git_sha
  }
}
