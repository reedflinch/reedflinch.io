#!/bin/bash

cd /reedflinch.io/infra || true

terraform init
terraform get
terraform fmt
terraform validate

terraform refresh
terraform plan -detailed-exitcode -out=this.plan

terraform apply this.plan

cd /reedflinch.io || true

rm -rf public/

hugo -v

aws s3 sync \
./public \
s3://reedflinch-io \
--exclude "index.html" \
--sse

aws s3 sync \
./public \
s3://reedflinch-io \
--exclude "*" \
--include "index.html" \
--cache-control "no-cache" \
--sse
