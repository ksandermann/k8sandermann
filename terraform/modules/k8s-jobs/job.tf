resource "kubernetes_job" "runner" {
  metadata {
    name = "runner001"
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
