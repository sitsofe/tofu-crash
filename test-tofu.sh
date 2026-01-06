#!/bin/bash
docker buildx create --name tofu-crash-builder --driver docker-container --bootstrap

if [[ $(arch) == "x86_64" ]]; then
  platform="linux/arm64"
else
  platform="linux/amd64"
fi

r=0
i=0
while [[ $r -eq 0 ]]; do
    i=$(( i + 1 ))
    echo $i
    docker buildx build --file Dockerfile --builder tofu-crash-builder --platform ${platform} -t tofu-crash --build-arg CACHE_BUSTER_VERSION="$(date +%s)" .
    r=$?
done
echo "$(date) Performed $i loop(s)"
