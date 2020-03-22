#!/usr/bin/env bash

if [ -n "${PRIVATE_GIT_SERVICE_REGISTRY+isset}" ] && [ -n "${BRANCH+isset}" ]
then
  git clone -b ${BRANCH} ${PRIVATE_GIT_SERVICE_REGISTRY} /tmp/service-registry
fi

exec java -server -noverify -Xmx2048M "org.springframework.boot.loader.WarLauncher"
