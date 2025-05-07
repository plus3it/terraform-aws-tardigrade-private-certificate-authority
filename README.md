## Overview

Once this certificate authority has been created, it will enter a "Pending" state, and output a Certificate Signing Request. The CSR needs to be self-signed (in the case of acmpca_certificate_authority.type being "ROOT") or signed by a root certificate authority if this is meant to be a "SUBORDINATE".

After signing, you will need to use the AWS PCA CLI to manually associate the signed cert back to the certificate authortiy, which will put it in an "Active" state. See <https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm-pca/index.html> for console reference.

If the PCA and certs it issues are in the same account, you can use CreatePermission to configure automatic renewal.

If the PCA and ACM reside in different accounts, share the PCA using a RAM Share to allow ACM in the other account to manage the certificate.

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_certificate_authority"></a> [private\_certificate\_authority](#input\_private\_certificate\_authority) | n/a | <pre>object({<br/>    s3_bucket = optional(object({<br/>      bucket        = string<br/>      force_destroy = bool<br/>      policy = object({<br/>        json = string<br/>      })<br/>    }))<br/><br/>    acmpca_certificate_authority = object({<br/>      enabled                         = bool<br/>      key_storage_security_standard   = optional(string)<br/>      permanent_deletion_time_in_days = optional(string)<br/>      tags                            = map(string)<br/>      type                            = optional(string)<br/>      usage_mode                      = optional(string)<br/><br/>      certificate_authority_configuration = object({<br/>        key_algorithm     = string<br/>        signing_algorithm = string<br/>        subject = object({<br/>          common_name                  = optional(string)<br/>          country                      = optional(string)<br/>          distinguished_name_qualifier = optional(string)<br/>          generation_qualifier         = optional(string)<br/>          given_name                   = optional(string)<br/>          initials                     = optional(string)<br/>          locality                     = optional(string)<br/>          organization                 = optional(string)<br/>          organizational_unit          = optional(string)<br/>          pseudonym                    = optional(string)<br/>          state                        = optional(string)<br/>          surname                      = optional(string)<br/>          title                        = optional(string)<br/>        })<br/>      })<br/><br/>      revocation_configuration = optional(object({<br/>        crl_configuration = optional(object({<br/>          custom_cname       = string<br/>          enabled            = bool<br/>          expiration_in_days = string<br/>          s3_object_acl      = string<br/>        }))<br/>        ocsp_configuration = optional(object({<br/>          enabled           = bool<br/>          ocsp_custom_cname = string<br/>        }))<br/>      }))<br/>    })<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_signing_request"></a> [certificate\_signing\_request](#output\_certificate\_signing\_request) | n/a |

<!-- END TFDOCS -->
