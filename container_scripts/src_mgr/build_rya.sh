#!/bin/bash

source /opt/.accumulo_rc.sh

#<<<run within container>>>
#use to do a mvn install of rya (does not deploy)

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

## VERIFY OPERATION
echo "<<< RUN WITHIN CONTAINER >>>"
echo "HAVE YOU RUN 'git pull' ON THE RYA REPO? "
echo "THIS WILL RUN A MVN CLEAN INSTALL (SKIPPING TESTS AND VAGRANT):"
continueOrQuit ''

## ON CONTINUE
echo " "
PROJ_DIR=/usr/local/src/incubator-rya
echo "...changing directory to $PROJDIR"
cd ${PROJ_DIR}
mvn -DskipTests=true -pl \!extras/vagrantExample clean install
echo " "
echo "finished operation (you are in '$(pwd)' dir)."


