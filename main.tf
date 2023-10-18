module "s3_bucket" {
  source = "git::https://github.com/plus3it/terraform-aws-tardigrade-s3-bucket.git?ref=5.0.0"
  count  = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration != null ? 1 : 0

  bucket        = var.private_certificate_authority.s3_bucket.bucket
  force_destroy = var.private_certificate_authority.s3_bucket.force_destroy
  policy        = var.private_certificate_authority.s3_bucket.policy
}


resource "aws_acmpca_certificate_authority" "this" {

  enabled                         = var.private_certificate_authority.acmpca_certificate_authority.enabled
  key_storage_security_standard   = var.private_certificate_authority.acmpca_certificate_authority.key_storage_security_standard
  permanent_deletion_time_in_days = var.private_certificate_authority.acmpca_certificate_authority.permanent_deletion_time_in_days
  tags                            = var.private_certificate_authority.acmpca_certificate_authority.tags
  type                            = var.private_certificate_authority.acmpca_certificate_authority.type
  usage_mode                      = var.private_certificate_authority.acmpca_certificate_authority.usage_mode

  certificate_authority_configuration {
    key_algorithm     = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.key_algorithm
    signing_algorithm = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.signing_algorithm

    subject {
      common_name                  = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.common_name
      country                      = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.country
      distinguished_name_qualifier = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.distinguished_name_qualifier
      generation_qualifier         = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.generation_qualifier
      given_name                   = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.given_name
      initials                     = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.initials
      locality                     = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.locality
      organization                 = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.organization
      organizational_unit          = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.organizational_unit
      pseudonym                    = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.pseudonym
      state                        = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.state
      surname                      = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.surname
      title                        = var.private_certificate_authority.acmpca_certificate_authority.certificate_authority_configuration.subject.title
    }
  }

  dynamic "revocation_configuration" {
    for_each = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration != null ? [1] : []

    content {
      dynamic "crl_configuration" {
        for_each = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration != null ? [1] : []
        content {
          custom_cname       = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration.custom_cname
          enabled            = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration.enabled
          expiration_in_days = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration.expiration_in_days
          s3_bucket_name     = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration.s3_bucket_name
          s3_object_acl      = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.crl_configuration.s3_object_acl
        }
      }

      dynamic "ocsp_configuration" {
        for_each = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.ocsp_configuration != null ? [1] : []
        content {
          enabled           = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.ocsp_configuration.enabled
          ocsp_custom_cname = var.private_certificate_authority.acmpca_certificate_authority.revocation_configuration.ocsp_configuration.ocsp_custom_cname
        }
      }
    }
  }
}
