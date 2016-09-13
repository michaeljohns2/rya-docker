#! /usr/bin/env bash

#<<<run as privileged>>>

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

DIR=$(pwd)

## VERIFY OPERATION
echo "<<< RUN AS PRIVILEGED USER >>>"
echo "THIS WILL <<<DELETE>>> THE FOLLOWING MAPPED FOLDERS, WILL BE REGENERATED ON RUN:"
echo "...$DIR/data"
echo "...$DIR/app_root"
echo "...$DIR/webapps"
continueOrQuit ''

## ON CONTINUE
echo " "

rm -fr $DIR/data
rm -fr $DIR/app_root
rm -fr $DIR/webapps

TAG="local/rya"
echo "...building docker image for $TAG"
docker build -t ${TAG} .
