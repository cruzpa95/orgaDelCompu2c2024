#!/bin/bash
# $1: should be bits ubuntu version (16 or 18)
# $2: should be bits version of OS (32 or 64)

UBUNTU_VERSION=$1
BITS_VERSION=$2

./mono-downloader-ubuntu-$UBUNTU_VERSION.sh
./mono-installer.sh
source edit-armsim-files.sh $BITS_VERSION