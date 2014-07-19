#!/bin/bash

source ./100-env.sh

cd ${DEBUILD_BUILD_DIR}

VERSION=$(ls | grep ${DEBUILD_APP_NAME} | grep -v "\.orig\." | grep ".tar.gz" | sed "s/${DEBUILD_APP_NAME}-//" | sed 's/\.tar\.gz//')

#delete all other files
find . -mindepth 1 -maxdepth 1 -not -name "${DEBUILD_APP_NAME}-${VERSION}.tar.gz" | xargs rm -rf

tar xzf ${DEBUILD_APP_NAME}-${VERSION}.tar.gz
cd ${DEBUILD_APP_NAME}-${VERSION}

dh_make -c ${DEBUILD_LICENCE} --createorig --single

cd debian
rm *.ex *.EX
rm docs README.*

cp -R ${DEBUILD_SCRIPT_DIR}/debian/* .

cd ..
debuild



