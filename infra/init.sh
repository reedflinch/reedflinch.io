#!/bin/bash

set -eu

bucket_name="terraform-remote-state-reedflinch-io"
table_name="terraform-remote-state-reedflinch-io"

# S3 bucket for storing remote Terraform state
aws s3api create-bucket \
--bucket "$bucket_name" \
--acl private

aws s3api put-bucket-versioning \
--bucket "$bucket_name" \
--versioning-configuration Status=Enabled

# DynamoDB table for getting a state lock
aws dynamodb create-table \
--table-name "$table_name" \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
