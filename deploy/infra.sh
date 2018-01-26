#!/bin/bash

cd infra || true

terraform init
terraform get
terraform fmt
terraform validate

terraform refresh
set +e
terraform plan -detailed-exitcode -out=this.plan

echo "$?"

# if [[ $? == 2 ]]; then
#   exit
# else
#   terraform apply this.plan
# fi
