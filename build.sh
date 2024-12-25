#!/bin/bash

VERSION=$(gitversion /showvariable MajorMinorPatch)
SHORTSHA=$(gitversion /showvariable ShortSha)

IMAGE="tmatwood/gitlab-runner-base"

echo "Building version $VERSION-$SHORTSHA."

docker buildx build -t $IMAGE:$VERSION-$SHORTSHA .
docker tag $IMAGE:$VERSION-$SHORTSHA $IMAGE:latest

docker push $IMAGE:$VERSION-$SHORTSHA
docker push $IMAGE:latest
