#!/bin/bash
packer build 
echo "mail_ami_id = '$(cat manifest.json | jq -r .builds[0].artifact_id |  cut -d':' -f2)'" > terraform.tfvars
terraform plan
terraform apply
