#!/bin/bash

source ./100-env.sh

cp onemoresamegame.spec ~/rpmbuild/SPECS/

cd ~/rpmbuild/SPECS

#download the source
spectool -g -R -f onemoresamegame.spec

#build
rpmbuild -ba onemoresamegame.spec
