ssh_public_key   = "/home/miroshnichenko_an/.ssh/id_rsa.pub"
username         = "miroshnichenko_an"

vpc_name = "dev_vpc"

vms_resources = {
     nat ={
       cores = 2
       memory = 1
       core_fraction = 5        
    },
     vm = {
       cores = 2
       memory = 2
       core_fraction = 5        
     }
}

vm-nat_ip_address = "192.168.10.254"