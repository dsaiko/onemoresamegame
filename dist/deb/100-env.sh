#!/bin/bash

export DEBUILD_NAME=OneMoreSameGame
export DEBUILD_SOURCE_URL=https://github.com/dsaiko/onemoresamegame.git
export DEBUILD_LICENCE=apache

export DEBFULLNAME="Dusan Saiko"
export DEBEMAIL="dusan.saiko@gmail.com"

export DEBUILD_APP_NAME=$(echo ${DEBUILD_SOURCE_URL} | sed 's/.*\///' | sed 's/\..*//')
export DEBUILD_SCRIPT_DIR=$(pwd)


source /etc/lsb-release 2> /dev/null
if [ -z "${DISTRIB_CODENAME}" ]
then
	export DISTRIB_CODENAME=$(cat /etc/debian_version | sed 's/\/.*//')
fi

if [ -n "$(dpkg-vendor --derives-from Ubuntu && echo yes)" ]
then
	export DISTRIB_FAMILY="ubuntu"
else
	export DISTRIB_FAMILY="debian"
fi

export DEBUILD_BUILD_DIR="build-${DISTRIB_FAMILY}-${DISTRIB_CODENAME}-$(file -L /sbin/init | sed -E 's/^[^0-9]*([^ ]*).*/\1/')"

