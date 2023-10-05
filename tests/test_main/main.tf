resource "random_string" "id" {
  length  = 8
  upper   = false
  special = false
  numeric = false
}

resource "random_string" "sub_id" {
  length  = 8
  upper   = false
  special = false
  numeric = false
}

module "private_ca_test" {
  source = "../.."

  private_certificate_authority = {
    s3_bucket = {
      bucket        = random_string.id.result
      force_destroy = true
      policy = {
        json = jsonencode({
          "Version" : "2012-10-17",
          "Statement" : [
            {
              "Effect" : "Allow",
              "Principal" : {
                "Service" : "acm-pca.amazonaws.com"
              },
              "Action" : [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
              ],
              "Resource" : [
                "arn:aws:s3:::${random_string.id.result}/*",
                "arn:aws:s3:::${random_string.id.result}"
              ],
              "Condition" : {
                "StringEquals" : {
                  "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
                }
              }
            }
          ]
        })
      }
    }

    acmpca_certificate_authority = {
      enabled                         = true
      type                            = "SUBORDINATE"
      key_storage_security_standard   = "FIPS_140_2_LEVEL_3_OR_HIGHER"
      permanent_deletion_time_in_days = "7"
      tags = {
        name = "broker_managed"
      }
      usage_mode = "SHORT_LIVED_CERTIFICATE"

      certificate_authority_configuration = {
        key_algorithm     = "RSA_2048"
        signing_algorithm = "SHA512WITHRSA"
        subject = {
          common_name = "${random_string.id.result}.com"
        }
      }

      revocation_configuration = {
        crl_configuration = {
          custom_cname       = "${random_string.sub_id.result}.${random_string.id.result}.com"
          enabled            = true
          expiration_in_days = "7"
          s3_bucket_name     = random_string.id.result
          s3_object_acl      = "BUCKET_OWNER_FULL_CONTROL"
        }
      }
    }
  }
}

data "aws_caller_identity" "current" {}
