#!/bin/bash

SOURCE_FILE=""
TARGET_FILE=""
DECRYPTION=""
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
   d) DECRYPTION=${OPTARG};;
   p) PASSPHRASE=$OPTARG;;
   esac
done


for FILE in $SOURCE_FILE $TARGET_FILE 
do

   echo $FILE

   if [[ -z $FILE || ! -f $FILE ]]
   then
       report_error "$FILE doesn't exist. Exiting."
       exit 1
   fi
done



exit 0