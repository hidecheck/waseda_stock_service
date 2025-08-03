#!/bin/bash


PROJECT_ID=waseda-android
REGION=asia-northeast1
FUNCTION_NAME=get-stock-price-v2

gcloud functions deploy $FUNCTION_NAME \
  --gen2 \
  --runtime=python310 \
  --region=$REGION \
  --source=../src \
  --entry-point=handler \
  --trigger-http \
  --project ${PROJECT_ID}

