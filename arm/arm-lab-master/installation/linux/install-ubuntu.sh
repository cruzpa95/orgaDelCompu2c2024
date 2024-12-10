#!/bin/bash

OS="$(hostnamectl | grep "Operating System" | sed -r -e 's/^.*Operating System: Ubuntu ([0-9]+).*$/\1/g')"
ARCH="$(hostnamectl | grep "Architecture" | sed -r -e 's/^.*Architecture: x86-([0-9]+).*$/\1/g')"

source install.sh $OS $ARCH