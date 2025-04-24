#!/bin/bash
set -e

docker buildx create --driver docker-container --name android-builder --use || true
docker buildx inspect --bootstrap

docker buildx build --platform linux/amd64,linux/arm64 --push -t werockstar/android-build:0.0.1-alpha06 .
