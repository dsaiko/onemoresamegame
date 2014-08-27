#!/bin/bash

source ./100-env.sh

VERSION=$(cat ${RPM_APP_NAME}.spec | egrep -i "^Version:" | sed 's/Version:\s*//')

rpmlint ~/rpmbuild/SPECS/${RPM_APP_NAME}.spec ~/rpmbuild/RPMS/*/${RPM_APP_NAME}-${VERSION}*.rpm ~/rpmbuild/SRPMS/${RPM_APP_NAME}-${VERSION}*.rpm