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

if [ -z "$(dpkg-vendor --derives-from Ubuntu && echo yes)" ]
then
	DIST_DEPENDS="qml-module-qtquick-controls (>=5.2.1), qml-module-qtquick-particles2 (>=5.2.1)"
else
	DIST_DEPENDS="qtdeclarative5-controls-plugin (>=5.2.1), qtdeclarative5-particles-plugin (>=5.2.1)"
fi

sed -i "s/\${dist:Depends}/${DIST_DEPENDS}/" control

cd ..
debuild



