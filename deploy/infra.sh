#!/bin/bash

cd infra || true

terraform init
terraform get
terraform fmt
terraform validate

terraform refresh
terraform plan -detailed-exitcode -out=this.plan

# terraform apply this.plan
