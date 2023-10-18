variable "private_certificate_authority" {
  type = object({
    s3_bucket = optional(object({
      bucket        = string
      force_destroy = bool
      policy = object({
        json = string
      })
    }))

    acmpca_certificate_authority = object({
      enabled                         = bool
      key_storage_security_standard   = optional(string)
      permanent_deletion_time_in_days = optional(string)
      tags                            = map(string)
      type                            = optional(string)
      usage_mode                      = optional(string)

      certificate_authority_configuration = object({
        key_algorithm     = string
        signing_algorithm = string
        subject = object({
          common_name                  = optional(string)
          country                      = optional(string)
          distinguished_name_qualifier = optional(string)
          generation_qualifier         = optional(string)
          given_name                   = optional(string)
          initials                     = optional(string)
          locality                     = optional(string)
          organization                 = optional(string)
          organizational_unit          = optional(string)
          pseudonym                    = optional(string)
          state                        = optional(string)
          surname                      = optional(string)
          title                        = optional(string)
        })
      })

      revocation_configuration = optional(object({
        crl_configuration = optional(object({
          custom_cname       = string
          enabled            = bool
          expiration_in_days = string
          s3_object_acl      = string
        }))
        ocsp_configuration = optional(object({
          enabled           = bool
          ocsp_custom_cname = string
        }))
      }))
    })
  })
}
