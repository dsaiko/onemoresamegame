#!/bin/bash

export DEBUILD_NAME=OneMoreSameGame
export DEBUILD_BUILD_DIR=build-$(file -L /sbin/init | sed -E 's/^[^0-9]*([^ ]*).*/\1/')
export DEBUILD_SOURCE_URL=https://github.com/dsaiko/onemoresamegame.git
export DEBUILD_LICENCE=apache

export DEBFULLNAME="Dusan Saiko"
export DEBEMAIL="dusan.saiko@gmail.com"

export DEBUILD_APP_NAME=$(echo ${DEBUILD_SOURCE_URL} | sed 's/.*\///' | sed 's/\..*//')
export DEBUILD_SCRIPT_DIR=$(pwd)




