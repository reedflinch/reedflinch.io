#!/bin/bash

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
