#!/bin/bash

if [ -z "$DOMAIN" ]
  then
    echo "No DOMAIN env variable is set"
    exit 127
fi

echo "Checking status of domain $DOMAIN"

status_code=$(curl --write-out %{http_code} --silent --output /dev/null $DOMAIN)

if [[ "$status_code" -gt 399 ]] ; then
  echo "Site status changed to $status_code"
  exit $status_code 
elif  [[ "$status_code" -gt 199 ]] ; then 
  echo "Site status is $status_code"
  exit 0
else
  echo "Invalid site status is $status_code"
  exit 128
fi
