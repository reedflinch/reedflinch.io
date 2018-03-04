#!/bin/bash

cd infra || true

echo
echo "--- Initializing ---"
echo
terraform init
terraform get

echo
echo "--- Validating ---"
echo
terraform fmt
terraform validate

terraform refresh

echo
echo "--- Planning ---"
echo
set +e
terraform plan -detailed-exitcode -out=this.plan

if [[ $? == 1 ]]; then
  echo
  echo "Encountered an error during `terraform plan`."
  echo "Exiting."
  exit 1
else
  echo
  echo "--- Applying ---"
  echo
  terraform apply this.plan
fi
