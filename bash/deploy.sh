#!/usr/bin/env bash

# WORK IN PROGRESS

if test "${X5E_ENV}" == "prod"; then
    echo
fi

./push-to-ecr.sh
../python/control.py redeploy arn:aws:ecs:us-east-1:401701269211:cluster/prod \
    arn:aws:ecs:us-east-1:401701269211:service/camera-prod