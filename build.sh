#!/bin/bash
set -o pipefail
IFS=$'\n\t'

DOCKER_SOCKET=/var/run/docker.sock

if [ ! -e "${DOCKER_SOCKET}" ]; then
  echo "Docker socket missing at ${DOCKER_SOCKET}"
  exit 1
fi


if [ -n "${SOURCE_IMAGE}" ]; then
  SOURCE_TAG="${SOURCE_REGISTRY}/${SOURCE_IMAGE}"
fi

if [ -n "${TARGET_IMAGE}" ]; then
  TARGET_TAG="${TARGET_REGISTRY}/${TARGET_IMAGE}"
fi
ls -lr /var/run/secrets/openshift.io/

if [[ -d /var/run/secrets/openshift.io/pull ]] && [[ ! -e /root/.dockercfg ]]; then
  cp /var/run/secrets/openshift.io/pull/.dockercfg /root/.dockercfg
fi

docker pull "${SOURCE_TAG}"
docker tag -f "${SOURCE_TAG}" "${TARGET_TAG}"
cp /tmp/secret1/.dockercfg /root/.dockercfg
if [ -d /tmp/secret1/.dockercfg ]; then

  echo "Found push secret"
  cp /tmp/secret1/.dockercfg /root/.dockercfg
fi
docker push "${TARGET_TAG}" 
docker rmi "${TARGET_TAG}" 


