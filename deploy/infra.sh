#!/bin/bash

cd infra || true

echo
echo "--- Initializing ---"
echo
terraform init
terraform get

echo
echo "--- Validating ---"
terraform fmt
terraform validate

terraform refresh

echo
echo "--- Planning ---"
set +e
terraform plan -detailed-exitcode -out=this.plan

if [[ $? == 1 ]]; then
  echo
  echo "Encountered an errorduring `terraform plan`. Exiting."
  exit
else
  echo
  echo "--- Applying ---"
  terraform apply this.plan
fi
