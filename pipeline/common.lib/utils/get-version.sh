#!/bin/bash
get-version()
{
    MAJOR=`sed -n 's/^MAJOR=\(.*\)/\1/p' < $1`
    MINOR=`sed -n 's/^MINOR=\(.*\)/\1/p' < $1`
    PATCH=`sed -n 's/^PATCH=\(.*\)/\1/p' < $1`
    IMAGE_NAME=`sed -n 's/^IMAGE_NAME=\(.*\)/\1/p' < $1`
    INSTALL_BASE_NAME=`sed -n 's/^INSTALL_BASE_NAME=\(.*\)/\1/p' < $1`
    if [ -z "$PATCH" ]
    then
        VERSION=${MAJOR}.${MINOR}
    else
        VERSION=${MAJOR}.${MINOR}.${PATCH}
    fi
    echo "$VERSION" "$IMAGE_NAME" "$INSTALL_BASE_NAME"
}