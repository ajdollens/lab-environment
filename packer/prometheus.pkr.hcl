build {
  name = "prometheus"

  source "source.googlecompute.base" {
    name              = "prometheus"
    image_name        = "prometheus-${local.timestamp}"
    instance_name     = "packer-${var.run_id}-prometheus"
    image_family      = "prometheus-candidate"
    image_description = "Prometheus built from ${var.git_sha}" 
    image_labels      = merge(local.common_labels, { role = "prometheus" })
  }
  
  # OS patching
  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbooks/base.yml"
    user          = "packer"
    use_proxy     = false
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }

  #prometheus install 
  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbooks/prometheus-install.yml"
    user          = "packer"
    use_proxy     = false 
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }

  # Alloy agent install
  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbooks/alloy-install.yml"
    user          = "packer"
    use_proxy     = false
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }

  # CIS lockdown runs last so it hardens everything above and can't block
  # earlier provisioners. Role is checked out into ansible/vendor/ by CI.
  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/vendor/UBUNTU24-CIS/site.yml"
    galaxy_file   = "${path.root}/../ansible/requirements.yml"
    user          = "packer"
    use_proxy     = false
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
      "--extra-vars", "@${path.root}/../ansible/vars/cis.yml",
    ]
  }
}
