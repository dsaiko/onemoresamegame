#!/bin/bash

source ./100-env.sh

rm -rf ${RPM_BUILD_DIR} 2>/dev/null
mkdir ${RPM_BUILD_DIR}
cd ${RPM_BUILD_DIR}
git clone ${RPM_SOURCE_URL}
cd ${RPM_APP_NAME}

git fetch --tags
LATEST=$(git describe --tags $(git rev-list --tags --max-count=1))
git checkout ${LATEST}

sed -i 's/\/opt\/$${TARGET}\/bin/\/usr\/bin/' deployment.pri

cd ..
cd ..
sed -i "s/^Version:.*/Version:        ${LATEST}/" onemoresamegame.spec












