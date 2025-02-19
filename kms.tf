//
// Create KMS Symmetric Key.
//
resource "yandex_kms_symmetric_key" "key-0" {
  name                = var.kms-key_name  
  default_algorithm   = var.algorithm
  rotation_period     = var.rotation_period
#   deletion_protection = true
#   lifecycle {
#     prevent_destroy = true
#   }
}

//
// Create a new KMS Assymetric Encryption Key.
# //
resource "yandex_kms_asymmetric_encryption_key" "key-a" {
  name                 = "example-asymetric-encryption-key"  
  encryption_algorithm = "RSA_2048_ENC_OAEP_SHA_256"
}