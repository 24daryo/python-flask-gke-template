#!/bin/bash

# ビルドするDockerイメージの名前
IMAGE_NAME="my-flask-app"

# Dockerイメージをビルド
docker build -t $IMAGE_NAME .

# Dockerコンテナを実行
docker run -p 5000:5000 $IMAGE_NAME