#!/usr/bin/env bash

if [ -n "${PRIVATE_GIT_SERVICE_REGISTRY+isset}" ]
then
  git clone -b ${PRIVATE_GIT_SERVICE_REGISTRY} /tmp/service-registry
fi

java -server -noverify -Xmx2048M "org.springframework.boot.loader.WarLauncher"
