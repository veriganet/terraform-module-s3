terraform {
  backend "local" {}
}

locals {
  name = "veriga-s3-test"
}

module "s3-test-bucket" {
  source = "../../s3"

  name = local.name
  region = "eu-west-1"
  versioning_enabled = false

  lifecycle_rules = [
    {
      enabled = false
      prefix = "test"
      abort_incomplete_multipart_upload_days = 7
      expiration_days = 30
      #expiration_date =
      expired_object_delete_marker = false
    }
  ]

  server_side_encryption_configuration_rules = [
    {
      sse_algorithm = "aws:kms"
    },
  ]
  # server_side_encryption_configuration_rules = [{}]


  policy = <<EOT
{
    "Version": "2012-10-17",
    "Id": "DefaultS3Policy",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::776553443280:root"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${local.name}",
                "arn:aws:s3:::${local.name}/*"
            ]
        }
    ]
}
EOT
}
