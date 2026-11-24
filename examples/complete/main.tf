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

provider "aws" {
  region = var.region
}

provider "awsutils" {
  region = var.region
}

module "s3_bucket" {
  source = "../../"

  user_enabled  = var.user_enabled
  acl           = var.acl
  force_destroy = var.force_destroy
  grants        = var.grants
  #lifecycle_rules               = var.lifecycle_rules
  lifecycle_configuration_rules = var.lifecycle_configuration_rules
  versioning_enabled            = var.versioning_enabled
  allow_encrypted_uploads_only  = var.allow_encrypted_uploads_only
  allowed_bucket_actions        = var.allowed_bucket_actions
  bucket_name                   = var.bucket_name
  object_lock_configuration     = var.object_lock_configuration
  s3_replication_enabled        = local.s3_replication_enabled
  s3_replica_bucket_arn         = join("", module.s3_bucket_replication_target.*.bucket_arn)
  s3_replication_rules          = local.s3_replication_rules
  privileged_principal_actions  = var.privileged_principal_actions
  privileged_principal_arns     = local.privileged_principal_arns
  transfer_acceleration_enabled = true
  bucket_key_enabled            = var.bucket_key_enabled

  context = module.context.self
}
