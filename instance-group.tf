data "yandex_compute_image" "instance-group" {  
  family = var.ig-image_family
}

//
// Create a new Compute Instance Group (IG)
//
resource "yandex_compute_instance_group" "group1" {
  name                = var.ig_name
  folder_id           = var.folder_id
  service_account_id  = var.service_account_id
#   deletion_protection = true
  instance_template {
    platform_id = var.vm-ig_platform
    resources {
      memory        = var.vms-ig_resources["memory"]
      cores         = var.vms-ig_resources["cores"]
      core_fraction = var.vms-ig_resources["core_fraction"]
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        # image_id = "fd827b91d99psvq5fjit"
        image_id = data.yandex_compute_image.instance-group.id
        size     = var.vms-ig_resources["disk"]
      }
    }
    network_interface {
      network_id = yandex_vpc_network.dev-vpc.id 
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = var.vm-nat_network_interface_nat
    }
    # labels = {
    #   label1 = "label1-value"
    #   label2 = "label2-value"
    # }
    metadata = {
    user-data          = data.template_file.cloudinit.rendered 
    serial-port-enable = 1
    }
    # network_settings {
    #   type = "STANDARD"
    # }
  }

  # variables = {
  #   test_key1 = "test_value1"
  #   test_key2 = "test_value2"
  # }

  scale_policy {
    fixed_scale {
      size = var.scale_policy
    }
  }

  allocation_policy {
    zones = var.allocation_policy
  }

  deploy_policy {
    max_unavailable = var.deploy_policy.max_unavailable
    max_creating    = var.deploy_policy.max_creating
    max_expansion   = var.deploy_policy.max_expansion
    max_deleting    = var.deploy_policy.max_deleting
  }
}