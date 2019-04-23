#!/bin/bash

readonly app=coderoso
readonly app_image=coderoso:latest
readonly app_dockerfile="./docker/coderoso/Dockerfile"

readonly nginx_image=nginx:latest
readonly nginx_dockerfile="./docker/nginx/Dockerfile"

readonly bzip_file=${app}-latest.tar.bz2

readonly app_key="~/.ssh/id_rsa"
readonly app_user="core@coderoso.io"

clear

echo "Building app and images..."
docker rmi -f ${app_image} 2>/dev/null
# env GOOS=linux GOARCH=386 make build
docker build --no-cache -t ${app_image} -f ${app_dockerfile} .

docker rmi -f ${nginx_image} 2>/dev/null
docker build --no-cache -t ${nginx_image} -f ${nginx_dockerfile} .

echo "Saving Docker images..."
docker save ${app_image} ${nginx_image} | bzip2 > ${bzip_file}
ls -lah ${bzip_file}

echo "Uploading Docker images..."
scp -i ${app_key} ${app}-latest.tar.bz2 docker-compose.yml ${app_user}:/home/core

ssh -i ${app_key} ${app_user} << ENDSSH
cd /home/core
bunzip2 --stdout ${bzip_file} | docker load
rm ${bzip_file}
docker-compose down && docker-compose up -d --force-recreate;
ENDSSH
