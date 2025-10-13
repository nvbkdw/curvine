#!/bin/bash
ROOT_DIR=$(cd ../../$(dirname $0); pwd)
echo "ROOT_DIR: ${ROOT_DIR}"

rm -rf build/dist/*

docker run -it --rm --name curvine-compile \
  -u root --privileged=true \
  -v ${ROOT_DIR}:/workspace \
  -w /workspace \
  --network host \
  curvine/curvine-compile:latest "build/build.sh --zip --package all"