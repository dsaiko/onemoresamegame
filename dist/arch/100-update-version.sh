#!/bin/bash

git fetch --tags
LATEST=$(git describe --tags $(git rev-list --tags --max-count=1))

sed -i "s/^pkgver=.*/pkgver=${LATEST}/" PKGBUILD
sed -i "s/github.com\/dsaiko\/onemoresamegame\/archive\/.*\.tar\.gz/github.com\/dsaiko\/onemoresamegame\/archive\/${LATEST}.tar.gz/" PKGBUILD

updpkgsums

