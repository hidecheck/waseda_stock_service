#!/bin/bash

REGION=asia-northeast1
FUNCTION_NAME=get-stock-price-v2

gcloud functions deploy $FUNCTION_NAME \
  --gen2 \
  --runtime=python313 \
  --region=$REGION \
  --source=../src \
  --entry-point=handler \
  --trigger-http
