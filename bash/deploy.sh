#!/usr/bin/env bash

# WORK IN PROGRESS
cd "$(dirname $0)"
../python/control.py redeploy arn:aws:ecs:us-east-1:401701269211:cluster/prod \
    arn:aws:ecs:us-east-1:401701269211:service/camera-prod