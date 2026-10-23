# Shared base for every image. Each build overrides name, image_name,
# image_family and image_labels.
source "googlecompute" "base" {
  project_id              = var.project_id
  zone                    = var.zone
  network                 = var.network
  subnetwork              = var.subnetwork
  source_image_family     = var.source_image_family
  source_image_project_id = ["ubuntu-os-cloud"]

  machine_type = "e2-medium"
  disk_size    = 20
  disk_type    = "pd-balanced"

  # SSH through IAP; firewall must allow tcp:22 from 35.235.240.0/20 to this tag
  ssh_username = "packer"
  use_iap      = true
  tags         = ["packer-build"]

  # Temp VM doesn't need GCP API access
  disable_default_service_account = true
}
