#!/bin/bash
# $1: should be bits ubuntu version (16 or 18)
# $2: should be bits version of OS (32 or 64)

UBUNTU_VERSION=$1
BITS_VERSION=$2

echo $UBUNTU_VERSION
echo $BITS_VERSION

source install.sh $1 $2

# Fix depency errors during installation
# Source: https://www.comoinstalarlinux.com/como-solucionar-problemas-al-instalar-o-actualizar-paquetes-en-ubuntu-o-linux-mint/
sudo dpkg --configure -a