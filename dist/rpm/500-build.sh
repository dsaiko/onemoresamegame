#!/bin/bash

source ./100-env.sh

cp onemoresamegame.spec ~/rpmbuild/SPECS/

cd ~/rpmbuild/SPECS

rpmbuild -ba onemoresamegame.spec
