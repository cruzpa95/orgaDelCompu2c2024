#!/bin/bash

# Check if the parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Set the filename variable
FILENAME="$1"

# Assemble the .asm file to an object file
nasm -f elf64 -g -F dwarf -l "$FILENAME.lst" -o "$FILENAME.o" "$FILENAME.asm"

# Compile the object file with gcc
gcc -no-pie -o "$FILENAME" "$FILENAME.o"

# Run gdb with the compiled file
gdb "$FILENAME"