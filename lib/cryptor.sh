#!/bin/bash

# Author: Ray Winkelman, raywinkelman@gmail.com
# Date: July 2017

# This program has 2 modes.
# These modes dictate the general flow of control. 
# They are encrypt mode, and decrypt mode.
# Encrypt mode is the default mode, unless decrypt is specified by the -d flag argument.

source_file=""
target_file=""
mode="E"
passphrase=""

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
      f) source_file=${OPTARG};;
      t) target_file=${OPTARG};;
      d) mode="D";;
      p) passphrase=$OPTARG;;
   esac
done

# Not null checks.
if [[ -z $source_file ]] ; then error "A Source File (-f) is required." ; fi
if [[ -z $target_file ]] ; then error "A Target File (-t) is required." ; fi
if [[ -z $passphrase ]] ; then error "A Passphrase (-p) is required." ; fi

# Filesystem checks.
if [[ ! -f $source_file ]] ; then error "Source File: $source_file doesn't exist." ; fi
if [[ ! -e $target_file ]] ; then touch -f "$target_file" 2>/dev/null || { error "Can't create $target_file"; } ; fi
if [[ ! -w $target_file ]] ; then error "Can't write to $target_file" ; fi


# Encrypt mode
if [ "$mode" == "E" ] ; then

  gpg -o "$target_file" --symmetric --armor --batch --yes --passphrase "$passphrase" --cipher-algo AES256 "$source_file" 2>/dev/null
  echo "Encrypted: $target_file"
  
# Decrypt mode
else
  gpg -o "$target_file" --batch --yes --passphrase "$passphrase" -d "$source_file" 1>/dev/null 2>&1
  echo "Decrypted: $target_file"
fi

exit 0