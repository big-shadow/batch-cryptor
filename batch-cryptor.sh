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
error() {
    echo -e "\e[31mERROR\e[0m: batch-cryptor.sh: $1"
}


# Not null checks.
if [[ -z $SOURCE_DIR ]] ; then
    error "A source directory is required."
fi

if [[ -z $TARGET_DIR ]] ; then
    error "A target directory is required."
fi

if [[ -z $PASSPHRASE ]] ; then
    error "A passphrase is required."
fi

# Filesystem checks.
if [[ ! -d $SOURCE_DIR ]] ; then
    error "Source Dir: $SOURCE_DIR doesn't exist."
fi

if [[ ! -d $TARGET_DIR ]] ; then
    error "Target Dir: $TARGET_DIR doesn't exist."
fi

if [[ ! -w $TARGET_DIR ]] ; then
   error "Can't write to $TARGET_DIR"
fi

echo -e "This will delete all files in: $TARGET_DIR \nDo you wish to proceed?"

select YN in "Yes" "No"; do
    case $YN in
        Yes ) break;;
        No ) exit;;
    esac
done

find "$TARGET_DIR" -mindepth 1 -delete
chmod 755 "$TARGET_DIR"

# Recurse into the target and encrypt/decrypt the files.
function crypt() 
{
   for ITEM in "${1}"/*    
   do

      SUFFIX=${ITEM#$SOURCE_DIR}
      SUFFIX=${SUFFIX%$ITEM}
      FULL_PATH="$TARGET_DIR$SUFFIX"
         
      # If it's a folder, recurse.
      if [[ -d $ITEM ]] ; then                   
         mkdir -p "$FULL_PATH"               
         crypt "$ITEM"     
      
      # Empty directory.   
      elif [[ $ITEM == *"/*"* ]] ; then
         continue
      else

         # Encrypt mode
         if [[ $MODE == "E" ]] ; then

            ./lib/cryptor.sh -f "$ITEM" -t "$FULL_PATH" -p "$PASSPHRASE" || { exit 1; }
            
         # Decrypt mode
         else
            ./lib/cryptor.sh -f "$ITEM" -t "$FULL_PATH" -p "$PASSPHRASE" -d || { exit 1; }
         fi

      fi
   done     
}

crypt "$SOURCE_DIR"

echo "Done."
exit 0