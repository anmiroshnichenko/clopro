data "yandex_compute_image" "nat-instance" {  
  family = var.nat-image_family
}

data "yandex_compute_image" "ubuntu" {  
  family = var.image_ubuntu
}

#Передача cloud-config в ВМ 
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)   
  }
}

# Nat-instance
resource "yandex_compute_instance" "nat-instance" {  
  name = local.name_nat
  platform_id = var.vm-nat_platform_id
  resources {    
    cores         = var.vms_resources["nat"]["cores"]
    memory        = var.vms_resources["nat"]["memory"]
    core_fraction = var.vms_resources["nat"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-instance.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_scheduling_policy
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id    
    nat       = var.vm-nat_network_interface_nat
    ip_address = var.vm-nat_ip_address
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}

# VM-1 with a public IP
resource "yandex_compute_instance" "vm-1" {  
  name = local.name_vm1
  platform_id = var.vm-nat_platform_id
  resources {    
    cores         = var.vms_resources["vm"]["cores"]
    memory        = var.vms_resources["vm"]["memory"]
    core_fraction = var.vms_resources["vm"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_scheduling_policy
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id    
    nat       = var.vm-nat_network_interface_nat    
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}


# VM-2 without a public IP
resource "yandex_compute_instance" "vm-2" {  
  name = local.name_vm2
  platform_id = var.vm-nat_platform_id
  resources {    
    cores         = var.vms_resources["vm"]["cores"]
    memory        = var.vms_resources["vm"]["memory"]
    core_fraction = var.vms_resources["vm"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {    
    preemptible = var.vm_scheduling_policy
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id    
    nat       = var.vm_network_interface_nat    
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}