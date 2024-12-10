#!/bin/bash

BITS_VERSION=$1
BASE_PATH=~/dotnet
ARMSIM_PATH=$BASE_PATH/ARMSim-201
USRLOCAL_PATH=/usr/local

# Move and renames files
mkdir $BASE_PATH
mkdir $ARMSIM_PATH
cp ./files/ARMSimLinuxFiles/* $ARMSIM_PATH
cp ./files/arm-none-eabi-as-$BITS_VERSION $ARMSIM_PATH/arm-none-eabi-as
chmod +x $ARMSIM_PATH/arm-none-eabi-as

# Add $USRLOCAL_PATH to $PATH if it isn't
if [ -d "$USRLOCAL_PATH" ] && [[ ":$PATH:" != *":$USRLOCAL_PATH:"* ]]; then
	PATH="${PATH:+"$PATH:"}$USRLOCAL_PATH"
fi

# Moves ARMSim to $USRLOCAL_PATH
sudo cp ./files/ARMSim $USRLOCAL_PATH/
sudo chmod +x $USRLOCAL_PATH/ARMSim