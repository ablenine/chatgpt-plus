#!/bin/bash

version=$1
arch=${2:-amd64}

# build go api program
cd ../api
if [ "$arch" = "amd64" ]; then
    make amd64
elif [ "$arch" = "arm64" ]; then
    make arm64
else
    echo "Unsupported architecture: $arch"
    exit 1
fi

# build web app
cd ../web
npm run build

cd ../build

# remove docker image if exists
docker rmi -f jpccr.ccs.tencentyun.com/ablexu/chatgpt-plus-api:$version-$arch
# build docker image for chatgpt-plus-go
docker build -t jpccr.ccs.tencentyun.com/ablexu/chatgpt-plus-api:$version-$arch -f dockerfile-api-go ../

# build docker image for chatgpt-plus-vue
docker rmi -f jpccr.ccs.tencentyun.com/ablexu/chatgpt-plus-web:$version-$arch
docker build --platform linux/amd64 -t jpccr.ccs.tencentyun.com/ablexu/chatgpt-plus-web:$version-$arch -f dockerfile-vue ../

if [ "$3" = "push" ];then
  docker push jpccr.ccs.tencentyun.com/ablexu/chatgpt-plus-api:$version-$arch
  docker push jpccr.ccs.tencentyun.com/ablexu/chatgpt-plus-web:$version-$arch
fi
