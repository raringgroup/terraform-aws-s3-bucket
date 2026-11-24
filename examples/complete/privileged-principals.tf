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
  account_id = data.aws_caller_identity.current.account_id

  # Must use derived values in order to validate `count` clauses
  privileged_principal_arns = var.privileged_principal_enabled == false ? [] : [
    {
      (aws_iam_role.deployment_iam_role[0].arn) = [""]
    },
    {
      (aws_iam_role.additional_deployment_iam_role[0].arn) = ["prefix1/", "prefix2/"]
    }
  ]

}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "deployment_assume_role" {
  count = var.privileged_principal_enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"] # example: this role can be used in an IAM Instance Profile
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "deployment_iam_policy" {
  count = var.privileged_principal_enabled ? 1 : 0

  statement {
    actions   = var.privileged_principal_actions
    effect    = "Allow"
    resources = ["arn:aws:s3:::${module.context.id}*"]
  }
}

resource "aws_iam_policy" "deployment_iam_policy" {
  count = var.privileged_principal_enabled ? 1 : 0

  policy = join("", data.aws_iam_policy_document.deployment_iam_policy.*.json)
}

module "deployment_principal_label" {
  source = "git::https://github.com/raringgroup/terraform-null-context.git?ref=v0.1.0"

  enabled = var.privileged_principal_enabled

  attributes = ["deployment"]

  context = module.context.self
}

resource "aws_iam_role" "deployment_iam_role" {
  count = var.privileged_principal_enabled ? 1 : 0

  name               = join("", module.deployment_principal_label.id)
  assume_role_policy = join("", data.aws_iam_policy_document.deployment_assume_role.*.json)

  tags = module.deployment_principal_label.tags
}

module "additional_deployment_principal_label" {
  source = "git::https://github.com/raringgroup/terraform-null-context.git?ref=v0.1.0"

  enabled = var.privileged_principal_enabled

  attributes = ["deployment", "additional"]

  context = module.context.self
}

resource "aws_iam_role" "additional_deployment_iam_role" {
  count = var.privileged_principal_enabled ? 1 : 0

  name               = join("", module.additional_deployment_principal_label.id)
  assume_role_policy = join("", data.aws_iam_policy_document.deployment_assume_role.*.json)

  tags = module.additional_deployment_principal_label.tags
}

resource "aws_iam_role_policy_attachment" "additional_deployment_role_attachment" {
  count = var.privileged_principal_enabled ? 1 : 0

  policy_arn = join("", aws_iam_policy.deployment_iam_policy.*.arn)
  role       = join("", aws_iam_role.deployment_iam_role.*.name)
}
