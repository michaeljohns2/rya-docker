#!/bin/bash

#<<<run as privileged user>>>
#chown all .m2 folders and files to the current user:user

function continueOrQuit {
  read -r -p "${1} Continue? [y/N] " response
    response=${response,,}    # tolower
    case $response in
      [y][e][s]|[y]) 
        echo "...continuing with operation"
        ;;
      *)
        echo "...aborting operation"
        exit 1
        ;;
    esac
} 

#user & group
_USER=${1}
_GROUP=${2}

## VERIFY OPERATION
echo "<<< RUN AS PRIVILEGED USER >>>"
echo "THESE ARGS MUST NOT BE EMPTY!!!"
echo "ARG1 (USER): '$_USER'"
echo "ARG2 (GROUP): '$_GROUP'"
echo " "
echo "THIS WILL CHOWN EVERYTHING IN '/home/$_USER/.m2' to '$_USER:$_GROUP':"
continueOrQuit ''

## ON CONTINUE
echo " "
chown -R "$_USER:$_GROUP" "/home/$_USER/.m2"
echo " "
echo "finished operation."


