# ########
# Provider
# ########

provider "aws" {
  region = var.region
}


# #########
# terraform
# #########
# rest of the backend part will be filled by terragrunt

terraform {
  backend "s3" {}
}

# ########
# IAM User
# ########

resource "aws_iam_user" "this" {
  count = var.user_enable == true ? 1 : 0
  name = var.name
}

# ##########
# IAM Policy
# ##########

resource "aws_iam_policy" "this" {
  count       = var.user_policy != null && var.user_enable == true ? 1 : 0
  name        = var.name
  description = var.user_policy_description
  policy      = var.user_policy
}

# #####################
# IAM Policy Attachment
# #####################

resource "aws_iam_user_policy_attachment" "this" {
  count      = var.user_policy != null && var.user_enable == true ? 1 : 0
  user       = aws_iam_user.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

# ###############
# User Access Key
# ###############

resource "aws_iam_access_key" "this" {
  count = var.user_enable == true ? 1 : 0
  user = aws_iam_user.this[0].name
}

# ############
# s3 resources
# ############

resource "aws_s3_bucket" "this" {
  bucket = var.name
  policy = var.policy

  dynamic "grant" {
    for_each = length(var.grants) > 0 ? var.grants : []

    content {
      id = lookup(grant.value, "canonical_id", "")
      permissions = split(",", lookup(grant.value, "permissions", ""))
      type = lookup(grant.value, "type", "")
      uri = lookup(grant.value, "uri", "" )
    }
  }

  dynamic "logging" {
    for_each = var.logging_target_bucket != "" ? [0] : []
    content {
      target_bucket = var.logging_target_bucket
      target_prefix = var.logging_target_prefix
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "cors_rule" {
    for_each = length(var.cors_rules) > 0 ? var.cors_rules: []
    content {
      allowed_headers = split(",", lookup(cors_rule.value, "allowed_headers", ""))
      allowed_methods = split(",", lookup(cors_rule.value, "allowed_methods", ""))
      allowed_origins = split(",", lookup(cors_rule.value, "allowed_origins", ""))
      expose_headers  = split(",", lookup(cors_rule.value, "expose_headers", ""))
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", "" )
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = length(var.server_side_encryption_configuration_rules) > 0 ? var.server_side_encryption_configuration_rules: []
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.sse_algorithm
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id = lookup(lifecycle_rule.value, "id", lifecycle_rule.key)
      prefix = lookup(lifecycle_rule.value, "prefix", "")
      enabled = lookup(lifecycle_rule.value, "enabled", false)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)

      expiration {
        date = lookup(lifecycle_rule.value, "expiration_date", null)
        days = lookup(lifecycle_rule.value, "expiration_days", null)
        expired_object_delete_marker = lookup(lifecycle_rule.value, "expired_object_delete_marker", false)
      }
    }
  }

  dynamic "website" {
    for_each = length(var.websites) > 0 ? var.websites : []
    content {
      index_document = lookup(website.value, "index_document", null)
      error_document = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules = lookup(website.value, "routing_rules", null)
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = (var.block_public_acls == true || var.block_public_policy == true || var.ignore_public_acls == true || var.restrict_public_buckets == true) ? 1 : 0
  bucket = aws_s3_bucket.this.id
  block_public_acls = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
