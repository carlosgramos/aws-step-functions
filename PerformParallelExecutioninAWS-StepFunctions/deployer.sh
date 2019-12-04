#!/bin/bash

aws cloudformation create-stack --stack-name parallel-functions-$(( $RANDOM % 20 + 1 )) --template-body file://cloudformation/template.yml --capabilities CAPABILITY_NAMED_IAM