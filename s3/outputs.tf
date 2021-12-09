output "key" {
  value = var.user_enable == true ? aws_iam_access_key.this[0].secret : "user disabled"
}

output "id" {
  value = var.user_enable == true ? aws_iam_access_key.this[0].id : "user disabled"
}

output "user_name" {
  value = var.user_enable == true ? aws_iam_user.this[0].name : "user disabled"
}

output "user_arn" {
  value = var.user_enable == true ? aws_iam_user.this[0].arn : "user disabled"
}

output "tfversion" {
  value = var.tfversion
}

output "name" {
  value = var.name
}
