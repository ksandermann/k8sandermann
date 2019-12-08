resource "kubernetes_config_map" "ansible_project" {
  metadata {
    name = "ansible-project"
  }

  binary_data = {
    "ansible.zip" = filebase64("/root/project/ansible.zip")
  }
}
