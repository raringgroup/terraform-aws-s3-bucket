## ----------------------------------------------------------------------------
## Copyright 2026 Raring Group LLC
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
## ----------------------------------------------------------------------------

output "bucket_domain_name" {
  value       = module.s3_bucket.bucket_domain_name
  description = "FQDN of bucket"
}

output "bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "Bucket ID"
}

output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "Bucket ARN"
}

output "replication_bucket_id" {
  value       = local.s3_replication_enabled ? join("", module.s3_bucket_replication_target.*.bucket_id) : null
  description = "Replication bucket ID"
}

output "replication_bucket_arn" {
  value       = local.s3_replication_enabled ? join("", module.s3_bucket_replication_target.*.bucket_arn) : null
  description = "Replication bucket bucket ARN"
}

output "replication_role_arn" {
  value       = module.s3_bucket.replication_role_arn
  description = "The ARN of the replication IAM Role"
}

output "bucket_region" {
  value       = module.s3_bucket.bucket_region
  description = "Bucket region"
}

output "user_name" {
  value       = module.s3_bucket.user_name
  description = "Normalized IAM user name"
}

output "user_arn" {
  value       = module.s3_bucket.user_arn
  description = "The ARN assigned by AWS for the user"
}

output "user_unique_id" {
  value       = module.s3_bucket.user_unique_id
  description = "The user unique ID assigned by AWS"
}
