#!/bin/bash

# Author: Ray Winkelman, raywinkelman@gmail.com
# Date: July 2017

# This program has 2 modes.
# These modes dictate the general flow of control. 
# They are encrypt mode, and decrypt mode.
# Encrypt mode is the default mode, unless decrypt is specified by the -d flag argument.

source_dir=""
target_dir=""
mode="E"
passphrase=""

while getopts s:t:p:d option
do
   case "${option}"
   in
      s) source_dir=${OPTARG};;
      t) target_dir=${OPTARG};;
      d) mode="D";;
      p) passphrase=${OPTARG};;
   esac
done

# Prints a formatted error to the console.
error() {
    echo -e "\e[31mERROR\e[0m: batch-cryptor.sh: $1"
    exit 1
}

# Not null checks.
if [[ -z $source_dir ]] ; then error "A Source Directory (-s) is required." ; fi
if [[ -z $target_dir ]] ; then error "A Target Directory (-t) is required." ; fi
if [[ -z $passphrase ]] ; then error "A Passphrase (-p) is required." ; fi

# Filesystem checks.
if [[ ! -d $source_dir ]] ; then error "Source Dir: $source_dir doesn't exist." ; fi
if [[ ! -d $target_dir ]] ; then error "Target Dir: $target_dir doesn't exist." ; fi
if [[ ! -w $target_dir ]] ; then error "Can't write to $target_dir" ; fi


echo -e "This will delete all files in: $target_dir \nDo you wish to proceed?"

select YN in "Yes" "No"; do
    case $YN in
        Yes ) break;;
        No ) exit 1;;
    esac
done

find "$target_dir" -mindepth 1 -delete
chmod 755 "$target_dir"

# Recurse into the target and encrypt/decrypt the files.
function crypt() 
{
   for item in "${1}"/*    
   do

      suffix=${item#$source_dir}
      suffix=${suffix%$item}
      full_path="$target_dir$suffix"
         
      # If it's a folder, recurse.
      if [[ -d $item ]] ; then                   
         mkdir -p "$full_path"               
         crypt "$item"     
      
      # Empty directory.   
      elif [[ $item == *"/*"* ]] ; then
         continue
      else

         # Encrypt mode
         if [[ $mode == "E" ]] ; then

            $(dirname $0)/lib/cryptor.sh -f "$item" -t "$full_path" -p "$passphrase" || { exit 1; }
            
         # Decrypt mode
         else
            $(dirname $0)/lib/cryptor.sh -f "$item" -t "$full_path" -p "$passphrase" -d || { exit 1; }
         fi

      fi
   done     
}

crypt "$source_dir"

echo "Done."
exit 0