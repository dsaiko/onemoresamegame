#!/bin/bash

source ./100-env.sh

cd ${DEBUILD_BUILD_DIR}
cd ${DEBUILD_APP_NAME}
version=$(git describe)

cd ..

mv ${DEBUILD_APP_NAME} ${DEBUILD_APP_NAME}-${version}

cd *

rm -rf .git .gitignore docs debian
cd ..

tar czf ${DEBUILD_APP_NAME}-${version}.tar.gz ${DEBUILD_APP_NAME}-${version}

rm -rf ${DEBUILD_APP_NAME}-${version}




