#!/bin/bash

# Dockerコンテナを停止
docker stop my-flask-app

# 停止したDockerコンテナを削除
docker rm my-flask-app