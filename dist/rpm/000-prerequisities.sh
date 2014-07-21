#!/bin/bash

sudo yum install @development-tools
sudo yum install fedora-packager
sudo yum install wget curl git gcc-c++
sudo yum install qt5-qtbase qt5-qtbase-devel qtchooser qt5-qtdeclarative qt5-qtdeclarative-devel qt5-qtquickcontrols

rpmdev-setuptree
