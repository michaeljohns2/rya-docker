#! /usr/bin/env bash

#shutdown running services run <<< run inside container >>>

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
echo "<<< RUN INSIDE THE CONTAINER >>>"
echo "THIS WILL STOP THE FOLLOWING SERVICES:"
echo "...tomcat"
echo "...accumulo"
echo "...zookeeper"
continueOrQuit ''

## ON CONTINUE
echo " "

source /opt/.accumulo_rc.sh

echo "...stopping tomcat"
catalina.sh stop
echo " "
echo "...stopping accumulo"
${ACCUMULO_HOME}/bin/stop-all.sh
echo " "
echo "...stopping zookeeper"
${ZOOKEEPER_HOME}/bin/zkServer.sh stop
echo " "
echo "all stopped."

