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

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.97.0" # blocked_encryption_types support (April 2026 SSE-C change)
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
  }
}
