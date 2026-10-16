build {
  name = "grafana"

  source "source.googlecompute.base" {
    name              = "grafana"
    image_name        = "grafana-${local.timestamp}"
    image_family      = "grafana-candidate"
    image_description = "Grafana built from ${var.git_sha}"
    image_labels      = merge(local.common_labels, { role = "grafana" })
  }

  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbooks/grafana.yml"
    user          = "packer"
    use_proxy     = false
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }
}
