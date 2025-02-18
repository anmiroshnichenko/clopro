resource "yandex_lb_network_load_balancer" "nlby" {
  name = "nlb"

  listener {
    name = "listener-web-servers"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.group1.load_balancer[0].target_group_id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# resource "yandex_lb_target_group" "web-servers" {
#   name           = "web-servers-target-group"

#   target {
#     subnet_id = "${yandex_vpc_subnet.public.id}"
#     address   = "${yandex_compute_instance.vm-1.network_interface[0].ip_address}"
#   }
  
#   target {
#     subnet_id = "${yandex_vpc_subnet.subnet-2.id}"
#     address   = "${yandex_compute_instance.vm-2.network_interface[0].ip_address}"
#   }
# }
