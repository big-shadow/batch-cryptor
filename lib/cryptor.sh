#!/bin/bash

# Author: Ray Winkelman, raywinkelman@gmail.com
# Date: July 2017

# This program has 2 modes.
# These modes dictate the general flow of control. 
# They are encrypt mode, and decrypt mode.
# Encrypt mode is the default mode, unless decrypt is specified by the -d flag argument.


SOURCE_FILE=""
TARGET_FILE=""
MODE="E"
PASSPHRASE=""

# Prints a formatted error to the console, then exits.
error() {
    echo -e "\e[31mERROR\e[0m: cryptor.sh: $1"
    exit 1
}


# Argument parsing and validation.
while getopts f:t:p:d option
do
   case "${option}"
   in
   f) SOURCE_FILE=${OPTARG};;
   t) TARGET_FILE=${OPTARG};;
   d) MODE="D";;
   p) PASSPHRASE=$OPTARG;;
   esac
done

# Not null checks.
if [[ -z $SOURCE_FILE ]] ; then
    error "A source file is required."
fi

if [[ -z $TARGET_FILE ]] ; then
    error "A target file is required."
fi

if [[ -z $PASSPHRASE ]] ; then
    error "A passphrase is required."
fi

# Filesystem checks.
if [[ ! -f $SOURCE_FILE ]] ; then
    error "Source File: $SOURCE_FILE doesn't exist."
fi

if [[ ! -e $TARGET_FILE ]] ; then
   touch -f "$TARGET_FILE" 2>/dev/null || { error "Can't create $TARGET_FILE"; }
fi

if [[ ! -w $TARGET_FILE ]] ; then
   error "Can't write to $TARGET_FILE"
fi

# Encrypt mode
if [ "$MODE" == "E" ] ; then

  gpg -o "$TARGET_FILE" --symmetric --armor --batch --yes --passphrase "$PASSPHRASE" --cipher-algo AES256 "$SOURCE_FILE"
  echo "Encrypted: $TARGET_FILE"
  
# Decrypt mode
else
  gpg -o "$TARGET_FILE" --batch --yes --passphrase "$PASSPHRASE" -d "$SOURCE_FILE" 1>/dev/null
  echo "Decrypted: $TARGET_FILE"
fi

exit 0