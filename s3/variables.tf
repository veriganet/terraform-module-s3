variable "region" {
  description = "AWS Region to be used (it effects all resources)"
  type        = string
}

variable "name" {
  description = "Name of the bucket"
  type = string
}

variable "versioning_enabled" {
  description = "Enable / disable versioning for the bucket"
  type = bool
  default = false
}

variable "lifecycle_rules" {
  description = "(Optional) A configuration of object lifecycle management (documented below)"
  type = list(map(string))
  default = [{}]
}

variable "server_side_encryption_configuration_rules" {
  description = "(Optional) A configuration of server-side encryption configuration (documented below)"
  type = list(map(any))
  default = []
}

variable "policy" {
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type = string
  default = null
}

variable "user_enable" {
  description = "Enable / disable IAM user creationg"
  type = bool
  default = false
}

variable "user_policy" {
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type = string
  default = null
}

variable "user_policy_description" {
  description = "(Optional) Description for user policy."
  type = string
  default = ""
}

variable "grants" {
  description = "(Optional) An ACL policy grant (documented below). Conflicts with acl."
  type = list(map(string))
  default = []
}

variable "block_public_acls" {
  description = "(Optional) Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs."
  type = bool
  default = true
}

variable "block_public_policy" {
  description = "(Optional) Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy."
  type = bool
  default = true
}

variable "ignore_public_acls" {
  description = "(Optional) Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set."
  type = bool
  default = false
}

variable "restrict_public_buckets" {
  description = "(Optional) Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked."
  type = bool
  default = false
}

variable "sse_algorithm" {
  description = "(required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type = string
  default = "AES256"
}

variable "logging_target_bucket" {
  description = "(Required) The name of the bucket that will receive the log objects."
  type        = string
  default     = ""
}

variable "logging_target_prefix" {
  description = "(Optional) To specify a key prefix for log objects."
  type        = string
  default     = ""
}

variable "cors_rules" {
  description = "(Optional) A rule of Cross-Origin Resource Sharing (documented below)."
  type        = list(map(string))
  default     = []
}

variable "websites" {
  description = "(Optional) A website object (documented below)."
  type = list(map(string))
  default     = []
}

variable "tfversion" {
  description = "Current terraform version"
  type        = string
  default     = null
}
