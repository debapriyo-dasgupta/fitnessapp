#!/bin/bash
get-base-image()
{
    IMAGE_NAME=`sed -n 's/^IMAGE_NAME=\(.*\)/\1/p' < $1`
    echo "$IMAGE_NAME"
}