//pipeline_configs = [
//  {
//    name   = "dockerhelm"
//    number = 1
//  },
//  {
//    name   = "dockeransible"
//    number = 2
//  },
//]

resource "kubernetes_job" "runner" {
  for_each = var.networks
  metadata {
    name = each.value.nameeins
  }
  spec {
    template {
      metadata {}
      spec {
        init_container {
          name  = "unzip"
          image = "ksandermann/multistage-builder:2019-09-17"
          command = [
            "/bin/sh",
            "-c",
            "unzip /tmp/ansible/ansible.zip -d /root/project"
          ]
          volume_mount {
            mount_path = "/tmp/ansible/"
            name       = "ansible-project"
          }
          volume_mount {
            mount_path = "/root/project"
            name       = "workdir"
          }
        }
        container {
          name  = "pipeline"
          image = "ksandermann/ansible:2.8.5"
          command = [
            "/bin/sh",
            "-c",
            "ansible-playbook /root/project/ansible/playbooks/hello.yml"
          ]
          env {
            name  = "ANSIBLE_ROLES_PATH"
            value = "/root/project/ansible/roles"
          }
          volume_mount {
            mount_path = "/root/project"
            name       = "workdir"
          }
        }
        volume {
          name = "ansible-project"
          config_map {
            name = "ansible-project"
          }
        }
        volume {
          name = "workdir"
          empty_dir {}
        }
      }
    }
    backoff_limit = 1
  }
}
