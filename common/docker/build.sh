#!/bin/bash

STAGE=$1
APP_NAME=$2
APP_PORT=$3
AWS_KEY=$4
AWS_REGION=$5
AWS_SECRET=$6
WORKERS=$7

docker build -t $APP_NAME:latest \
  --build-arg stage=$STAGE \
  --build-arg port=$APP_PORT \
  --build-arg aws_key=$AWS_KEY \
  --build-arg aws_secret=$AWS_SECRET \
  --build-arg aws_region=$AWS_REGION \
  --build-arg workers=$WORKERS \
  .