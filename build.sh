#!/bin/bash
set -o pipefail
IFS=$'\n\t'

DOCKER_SOCKET=/var/run/docker.sock

if [ ! -e "${DOCKER_SOCKET}" ]; then
  echo "Docker socket missing at ${DOCKER_SOCKET}"
  exit 1
fi


if [ -n "$SOURCE_IMAGE}" ]; then
  SOURCE_TAG="${SOURCE_REGISTRY}/${SOURCE_IMAGE}"
fi

if [ -n "${TARGET_IMAGE}" ]; then
  TARGET_TAG="${TARGET_REGISTRY}/${TARGET_IMAGE}"
fi

docker pull "${SOURCE_TAG}"
docker tag "${SOURCE_TAG}" ${TARGET_TAG}
docker push "${TARGET_TAG}" 
ll -r /var/run/secrets/openshift.io/push/
if [[ -d /var/run/secrets/openshift.io/push ]] && [[ ! -e /root/.dockercfg ]]; then
  cp /var/run/secrets/openshift.io/push/.dockercfg /root/.dockercfg
fi
if [[ -d /var/run/secrets/openshift.io/push ]] && [[ ! -e /root/.dockercfg ]]; then
  cp /var/run/secrets/openshift.io/push/.dockercfg /root/.dockercfg
fi

if [ -n "${OUTPUT_IMAGE}" ] || [ -s "/root/.dockercfg" ]; then
  docker push "${TAG}"
fi
