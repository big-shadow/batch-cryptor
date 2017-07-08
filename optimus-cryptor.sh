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

# Prints a formatted error to the console.
report_error() {
    echo -e "\e[31mERROR\e[0m: $1"
}


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


if [[ -z $SOURCE_FILE || ! -f $SOURCE_FILE ]] ; then
    report_error "$SOURCE_FILE doesn't exist. Exiting."
    exit 1
fi

if [ ! -e "$TARGET_FILE" ] ; then
   touch "$TARGET_FILE" 2>/dev/null || { echo "Cannot create $TARGET_FILE" >&2; exit 1; }
fi

if [ ! -w "$TARGET_FILE" ] ; then
   report_error "Cannot write to $TARGET_FILE"
   exit 1
fi


exit 0