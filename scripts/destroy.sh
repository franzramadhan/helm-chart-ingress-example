# /usr/bin/env bash

kind delete cluster || true
docker-compose down || true
docker rmi -f franzramadhan/backend:latest || true
