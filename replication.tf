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

resource "aws_iam_role" "replication" {
  count = local.replication_enabled ? 1 : 0

  name               = format("%s-replication", module.context.id)
  assume_role_policy = data.aws_iam_policy_document.replication_sts[0].json
}

data "aws_iam_policy_document" "replication_sts" {
  count = local.replication_enabled ? 1 : 0

  statement {
    sid    = "AllowPrimaryToAssumeServiceRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "replication" {
  count = local.replication_enabled ? 1 : 0

  name   = format("%s-replication", module.context.id)
  policy = data.aws_iam_policy_document.replication[0].json
}

data "aws_iam_policy_document" "replication" {
  count = local.replication_enabled ? 1 : 0

  statement {
    sid    = "AllowPrimaryToGetReplicationConfiguration"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.default[0].arn,
      "${aws_s3_bucket.default[0].arn}/*"
    ]
  }

  statement {
    sid    = "AllowPrimaryToReplicate"
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]

    resources = toset(concat(
      try(length(var.s3_replica_bucket_arn), 0) > 0 ? ["${var.s3_replica_bucket_arn}/*"] : [],
      [for rule in local.s3_replication_rules : "${rule.destination_bucket}/*" if try(length(rule.destination_bucket), 0) > 0],
    ))
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  count      = local.replication_enabled ? 1 : 0
  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn
}
