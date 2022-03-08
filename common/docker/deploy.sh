#!/bin/bash

AWS_REGION=$1
ACCOUNT_ID=$2
APP_NAME=$3
TAG_NAME=$4
CLUSTER=$5

REPOSITORY="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"


echo "🕑 Getting service ARN..."

export SERVICE_ARN=$(aws ecs list-services --cluster $CLUSTER --region $AWS_REGION | jq -r --arg name "$APP_NAME" '.serviceArns[] | select( . | test($name) )')

echo "🕑 Getting servicxe name..."

SERVICE_NAME=$(perl -e 'my @service = split /\//, "$ENV{SERVICE_ARN}"; print $service[2];')


echo "🕑 Getting task definition..."

TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition $APP_NAME --region $AWS_REGION)
SET_IMAGE=".taskDefinition.containerDefinitions[0].image=\"$REPOSITORY/$APP_NAME:$TAG_NAME\""

echo $TASK_DEFINITION | jq $SET_IMAGE | jq '.taskDefinition' | \
  jq 'del(.taskDefinitionArn)' | \
  jq 'del(.revision)' | \
  jq 'del(.status)' | \
  jq 'del(.requiresAttributes)' | \
  jq 'del(.capabilities)' | \
  jq 'del(.compatibilities)' | \
  jq 'del(.registeredAt)' | \
  jq 'del(.registeredBy)' \
  > task-definition.json


echo "🆕 Create new Task revision..."

TASK_VERSION=$(aws ecs register-task-definition \
  --family $APP_NAME \
  --region $AWS_REGION \
  --cli-input-json file://$(pwd)/task-definition.json | jq '.taskDefinition.revision')


if [ -n "$TASK_VERSION" ]; then
  echo "🆕 Updating service..."
  echo
  echo "🔎 Update ECS Cluster: $CLUSTER"
  echo "🔎 Service: $SERVICE_NAME"
  echo "🔎 Task Definition: $APP_NAME:$TASK_VERSION"


  DEPLOYED_SERVICE=$(aws ecs update-service --cluster $CLUSTER --service $SERVICE_NAME --task-definition $APP_NAME:$TASK_VERSION | jq --raw-output '.service.serviceName')
  echo "\n🚀🚀 Deployment of $DEPLOYED_SERVICE complete!!"
else
    echo "exit: No task definition"
    exit;
fi
