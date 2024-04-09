#!/usr/bin/env bash
set -e

DEPENDENCIES=(docker)
REPOSITORY_NAME="backgrounds"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# help message
for ARGUMENT in "$@"; do
    if [ "$ARGUMENT" == "-h" ] || [ "$ARGUMENT" == "--help" ]; then
        echo "usage: $(basename "$0")"
        echo "Pack backgrounds using docker."
        exit
    fi
done

# check dependencies
for CMD in "${DEPENDENCIES[@]}"; do
    if [[ -z "$(which "$CMD")" ]]; then
        echo "\"${CMD}\" is missing!"
        exit 1
    fi
done

PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
VERSION="$(cat Version.txt)"

mkdir --parents builds

docker run --pull always --rm \
    --env "GOCACHE=/media/build-cache/gocache" \
    --env "GOPATH=/media/build-cache/gopath" \
    --env "VERSION=$VERSION" \
    --volume "${REPOSITORY_NAME}-build-cache:/media/build-cache" \
    --volume "${PROJECT_DIR}:/media/workdir" \
    --workdir /media/workdir \
    madebytimo/scripts \
    compress.sh --output "builds/${REPOSITORY_NAME}-${VERSION}" backgrounds
