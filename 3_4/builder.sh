#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-image>"
  exit 1
fi

if [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PWD" ]; then
  echo "DOCKER_USER and DOCKER_PWD environment variables must be set"
  exit 1
fi

set -e

GITHUB_REPO=$1
DOCKER_IMAGE=$2

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

echo "$DOCKER_PWD" | docker login -u "$DOCKER_USER" --password-stdin

git clone "https://github.com/$GITHUB_REPO.git" "$WORKDIR"

docker build -t "$DOCKER_IMAGE" "$WORKDIR"

docker push "$DOCKER_IMAGE"