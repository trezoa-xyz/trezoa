#!/usr/bin/env bash
set -ex

cd "$(dirname "$0")"


platform=()
if [[ $(uname -m) = arm64 ]]; then
  # Ref: https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/#tldr
  platform+=(--platform linux/amd64)
fi

docker build "${platform[@]}" -t trezoalabs/rust .

read -r rustc version _ < <(docker run trezoalabs/rust rustc --version)
[[ $rustc = rustc ]]
docker tag trezoalabs/rust:latest trezoalabs/rust:"$version"
docker push trezoalabs/rust:"$version"
docker push trezoalabs/rust:latest
