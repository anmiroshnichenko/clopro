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

// Object-storage vars
bucket_name = "miroshnichenko-15-02"
max_size-bucket = 1048576
anonymous_access = {
  read        = true
  list        = false
  config_read = false
}

storage_object = {
  key         = "elt.jpg"
  source      = "/home/miroshnichenko_an/clopro/elt.jpg"
}

// Compute Instance Group vars (IG)
ig_name = "frontend"
ig-image_family = "lamp"
scale_policy = 3
vms-ig_resources = {
  cores = 2
  memory = 2
  core_fraction = 5        
  disk = 8  
}
deploy_policy = {
  "max_unavailable" = 1
  "max_creating"    = 1
  "max_expansion"   = 1
  "max_deleting"    = 2
}

// KMS vars
kms-key_name = "key-0"
algorithm    = "AES_256"