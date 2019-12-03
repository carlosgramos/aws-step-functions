#!/bin/bash

aws cloudformation create-stack --stack-name step-functions-$(uuidgen) --template-body file://cloudformation/template.yml --capabilities CAPABILITY_NAMED_IAM