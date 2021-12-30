#!/bin/bash
packer build packer_webauto.json 
terraform init
terraform apply
