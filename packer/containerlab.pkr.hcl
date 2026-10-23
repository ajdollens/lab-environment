build{
  name = "containerlab" 
  source "source.googlecompute.base" {
    name              = "containerlab"
    image_name        = "containerlab-${local.timestamp}"
    image_family      = "containerlab-candidate"
    image_description = "containerlab built from ${var.git_sha}" 
    image_labels      = merge(local.common_labels, { role = "containerlab" })
  }

  provisioner "ansible"{
    playbook_file = "${path.root}/../ansible/playbooks/base.yml"
    user          = "packer"
    use_proxy     = false
    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
    ]
  }
  # containerlab install
  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbooks/containerlab-install.yml"
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

  #CIS Lockdown 
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