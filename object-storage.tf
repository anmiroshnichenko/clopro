# // Создание сервисного аккаунта
# resource "yandex_iam_service_account" "sa" {
#   name = "object-storage"
# }

# // Назначение роли сервисному аккаунту
# resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
#   folder_id = var.folder_id
#   role      = "storage.admin"
#   member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
# }

# // Создание статического ключа доступа
# resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
#   service_account_id = yandex_iam_service_account.sa.id
#   description        = "static access key for object storage"
# }

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.bucket_name
  max_size              = var.max_size-bucket
  default_storage_class = var.default_storage_class
  anonymous_access_flags {
    read        = var.anonymous_access.read
    list        = var.anonymous_access.list
    config_read = var.anonymous_access.config_read
  } 

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-0.id
        sse_algorithm     = "aws:kms"
      }
    }
  } 
}

resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.test.bucket  
  key         = "elt.jpg"
  source      = "/home/miroshnichenko_an/clopro/elt.jpg"  
  content_type = "image/jpg"       
}
