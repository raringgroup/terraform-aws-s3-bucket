## ----------------------------------------------------------------------------
## Copyright 2026 Raring Group LLC
## Copyright 2019-2023 Cloud Posse, LLC
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
##
## Modified from terraform-aws-s3-bucket (https://github.com/cloudposse/terraform-aws-s3-bucket) by Raring Group LLC.
## ----------------------------------------------------------------------------

locals {
  s3_replication_enabled = var.s3_replication_enabled
  s3_replication_rules = local.s3_replication_enabled ? [
    {
      id                 = "replication-test-explicit-bucket"
      status             = "Enabled"
      prefix             = "/extra"
      priority           = 5
      destination_bucket = module.s3_bucket_replication_target_extra[0].bucket_arn
      destination = {
        account_id = local.account_id
        metrics = {
          status = null
        }
      }
    },
    {
      id                 = "replication-test-metrics"
      status             = "Enabled"
      prefix             = "/with-metrics"
      priority           = 10
      destination_bucket = null
      destination = {
        account_id = local.account_id
        metrics = {
          status = "Enabled"
        }
      }
    }
  ] : []
}

module "s3_bucket_replication_target" {
  count = local.s3_replication_enabled ? 1 : 0

  source = "../../"

  user_enabled                = true
  acl                         = "private"
  force_destroy               = true
  versioning_enabled          = true
  s3_replication_source_roles = [module.s3_bucket.replication_role_arn]

  attributes = ["target"]
  context    = module.context.self
}

module "s3_bucket_replication_target_extra" {
  count = local.s3_replication_enabled ? 1 : 0

  source = "../../"

  user_enabled                = true
  acl                         = "private"
  force_destroy               = true
  versioning_enabled          = true
  s3_replication_source_roles = [module.s3_bucket.replication_role_arn]

  attributes = ["target", "extra"]
  context    = module.context.self
}
