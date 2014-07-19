#!/bin/bash

source ./100-env.sh

rm -rf ${DEBUILD_BUILD_DIR} 2>/dev/null
mkdir ${DEBUILD_BUILD_DIR}
cd ${DEBUILD_BUILD_DIR}
git clone ${DEBUILD_SOURCE_URL}
cd ${DEBUILD_APP_NAME}

git fetch --tags
LATEST=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout ${LATEST}

sed -i 's/\/opt\/$${TARGET}\/bin/\/usr\/games/' deployment.pri







