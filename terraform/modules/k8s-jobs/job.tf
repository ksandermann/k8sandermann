resource "kubernetes_job" "runner" {
  for_each = var.k8s_pipeline_configs
  metadata {
    name      = each.value.pipeline_name
    namespace = var.k8s_pipeline_namespace
  }
  spec {
    active_deadline_seconds = 3600 //Specifies the duration in seconds relative to the startTime that the job may be active before the system tries to terminate it; value must be positive integer
    backoff_limit           = 1    //Specifies the number of retries before marking this job failed. Defaults to 6
    completions             = 1    //Specifies the desired number of successfully finished pods the job should be run with.
    parallelism             = 1    //Specifies the maximum desired number of pods the job should run at any given time


    template {
      metadata {}
      spec {
        active_deadline_seconds          = 3600
        automount_service_account_token  = false
        dns_policy                       = "ClusterFirst"
        host_ipc                         = false
        host_network                     = false
        host_pid                         = false
        restart_policy                   = "Never"
        share_process_namespace          = false
        termination_grace_period_seconds = 30

        init_container {
          name              = "unzip"
          image             = var.k8s_pipeline_container_unzip_image
          image_pull_policy = "Always"
          command           = ["/bin/sh"]
          args = [
            "-c",
            "unzip ${var.ansible_codebase_mountpath}/${var.ansible_configmap_zip_filename} -d ${var.k8s_pipeline_container_workdir}"
          ]
          stdin      = false
          stdin_once = false
          tty        = false

          resources {
            requests {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          volume_mount {
            mount_path = var.ansible_codebase_mountpath
            name       = "ansible-codebase"
          }
          volume_mount {
            mount_path = var.k8s_pipeline_container_workdir
            name       = "workdir"
          }
        }
        container {
          name              = "builder"
          image             = each.value.builder_image
          image_pull_policy = "IfNotPresent"
          command           = ["/bin/sh"]
          args = [
            "-c",
            "ansible-playbook ${var.k8s_pipeline_container_workdir}/ansible/playbooks/${each.value.playbook_filename}"
          ]
          stdin      = false
          stdin_once = false
          tty        = false

          resources {
            requests {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          env {
            name  = "ANSIBLE_ROLES_PATH"
            value = "${var.k8s_pipeline_container_workdir}/ansible/roles"
          }
          volume_mount {
            mount_path = var.k8s_pipeline_container_workdir
            name       = "workdir"
          }
        }
        volume {
          name = "ansible-codebase"
          config_map {
            name         = var.ansible_configmap_name
            default_mode = "0644"
          }
        }
        volume {
          name = "workdir"
          empty_dir {}
        }
      }
    }
  }
}
