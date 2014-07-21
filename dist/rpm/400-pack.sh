#!/bin/bash

source ./100-env.sh

cd ${RPM_BUILD_DIR}
cd ${RPM_APP_NAME}

VERSION=$(git describe)

rm -rf .git

cd ..

mv ${RPM_APP_NAME} ${RPM_APP_NAME}-${VERSION}
tar cvzf ${RPM_APP_NAME}-${VERSION}.tar.gz ${RPM_APP_NAME}-${VERSION}
rm -rf ${RPM_APP_NAME}-${VERSION}

mv ${RPM_APP_NAME}-${VERSION}.tar.gz ~/rpmbuild/SOURCES/

cd ..

rm -rf ${RPM_BUILD_DIR}


