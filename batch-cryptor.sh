#!/bin/bash

# Author: Ray Winkelman, raywinkelman@gmail.com
# Date: July 2017

# This program has 2 modes.
# These modes dictate the general flow of control. 
# They are encrypt mode, and decrypt mode.
# Encrypt mode is the default mode, unless decrypt is specified by the -d flag argument.

SOURCE_DIR=""
TARGET_DIR=""
MODE="E"
PASSPHRASE=""

while getopts s:t:p:d option
do
   case "${option}"
   in
   s) SOURCE_DIR=${OPTARG};;
   t) TARGET_DIR=${OPTARG};;
   d) MODE="D";;
   p) PASSPHRASE=$OPTARG;;
   esac
done

# Prints a formatted error to the console.
report_error() {
    echo -e "\e[31mERROR\e[0m: batch-cryptor.sh: $1"
}


# Not null checks.
if [[ -z $SOURCE_DIR ]] ; then
    report_error "A source directory is required."
    exit 1
fi

if [[ -z $TARGET_DIR ]] ; then
    report_error "A target directory is required."
    exit 1
fi

if [[ -z $PASSPHRASE ]] ; then
    report_error "A passphrase is required!"
    exit 1
fi

# Filesystem checks.
if [[ ! -d $SOURCE_DIR ]] ; then
    report_error "Source Dir: $SOURCE_DIR doesn't exist. Exiting."
    exit 1
fi

if [[ ! -d $TARGET_DIR ]] ; then
    report_error "Target Dir: $TARGET_DIR doesn't exist. Exiting."
    exit 1
fi

if [[ ! -w $TARGET_DIR ]] ; then
   report_error "Cannot write to $TARGET_DIR"
   exit 1
fi

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"
chmod 755 "$TARGET_DIR"

# Recurse into the target and encrypt/decrypt the files.
function crypt {
   for ITEM in $1/*      
   do

      RELATIVE_DIR=${ITEM#$SOURCE_DIR}
      RELATIVE_DIR=${RELATIVE_DIR%$ITEM}

      # If it's a folder, recuse.
      if [[ -d $ITEM ]] ; then                   
         mkdir -p "$TARGET_DIR$RELATIVE_DIR"               
         crypt $ITEM                  
      else

         # Encrypt mode
         if [[ $MODE == "E" ]] ; then

            ./lib/cryptor.sh -f "$ITEM" -t "$TARGET_DIR$RELATIVE_DIR" -p "$PASSPHRASE"
            
         # Decrypt mode
         else
            ./lib/cryptor.sh -f "$ITEM" -t "$TARGET_DIR$RELATIVE_DIR" -p "$PASSPHRASE" -d

         fi
         
         rm -f "$ITEM"
      fi
   done     
}

crypt $SOURCE_DIR

rm -rf "$SOURCE_DIR"
mkdir -p "$SOURCE_DIR"

echo "Done."
exit 0