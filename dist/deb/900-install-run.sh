#!/bin/bash

source ./100-env.sh

cd ${DEBUILD_BUILD_DIR}

sudo dpkg -i *.deb
sudo apt-get install -f

/usr/games/onemoresamegame


