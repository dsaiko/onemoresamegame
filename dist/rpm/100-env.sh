#!/bin/bash

export RPM_SOURCE_URL=https://github.com/dsaiko/onemoresamegame.git
export RPM_LICENCE=apache

export RPM_APP_NAME=$(echo ${RPM_SOURCE_URL} | sed 's/.*\///' | sed 's/\..*//')
export RPM_SCRIPT_DIR=$(pwd)


export RPM_BUILD_DIR="build-$(file -L /sbin/init | sed -E 's/^[^0-9]*([^ ]*).*/\1/')"

