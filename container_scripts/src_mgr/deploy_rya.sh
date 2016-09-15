#!/bin/bash

#just in case, source environment
source /opt/.accumulo_rc.sh

#<<<run within container>>>
#use to do deploy the latest rya.web war from local '.m2' (does not build)

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
echo "<<< RUN WITHIN CONTAINER AND ENSURE TOMCAT IS ALREADY RUNNING (IT WON'T BE CYCLED) >>>"
echo "HAVE YOU RUN './build_rya.sh' FOR THE LATEST BUILD? "
echo "THIS WILL REPLACE EXISTING RYA.WEB WAR WITH MOST RECENT IN YOUR LOCAL '.m2':"
echo "NOTE: AFTER THIS IS RUN, YOU MAY NEED TO SEPARATELY RUN 'remove_rya_conflicts.sh' DUE TO DEPLOY DELAYS"
continueOrQuit ''

## ON CONTINUE
echo " "

function echoerr() { printf "%s\n" "$*" >&2; }

function doExit {
    if [ $? -ne 0 ]; then
         echoerr "--------------------------"
         echoerr "-"
         echoerr "- failed" "$@"
         echoerr "-"
         echoerr "- exiting..."
         echoerr "-"
         echoerr "--------------------------"
         exit 800
    fi
    # otherwise exit normally
    exit
}

### wait for a directory to exist or 60 seconds timeout
function waitForDeploy {
    waitfordir="$1"
    timeout=60
    while [[ ! -d  "$waitfordir" ]]  
    do
        sleep 5
        let timeout-=5
        if [[ $timeout -le "0" ]]; then 
            echo "Timeout waiting for war to deploy, $waitfordir still does not exist."; 
            doExit 401 
        fi
    done
}

echo "Deploy Rya Web"
ryaWar=web.rya-${RYA_EXAMPLE_VERSION}.war

if [ -f ${APP_ROOT}/${ryaWar} ]; then
    echo "...creating a backup of existing ${ryaWar}"
    mv ${APP_ROOT}/${ryaWar} ${APP_ROOT}/${ryaWar}.bak
fi

echo "...copying latest ${ryaWar} from local .m2"
cp /root/.m2/repository/org/apache/rya/web.rya/${RYA_EXAMPLE_VERSION}/${ryaWar} ${APP_ROOT}

if [ -d ${WEBAPPS_DIR}/web.rya ]; then
    echo "...removing existing web.rya dir"
    rm -rf ${WEBAPPS_DIR}/web.rya
fi

echo "...copying ${ryaWar} to ${WEBAPPS_DIR} (should trigger deploy)"
cp ${APP_ROOT}/${ryaWar} ${WEBAPPS_DIR}/web.rya.war

echo "...waiting for Tomcat to deploy web.rya"
# Wait for the war to deploy
waitForDeploy ${WEBAPPS_DIR}/web.rya/WEB-INF/classes/

echo "...removing conflicting rya.web jars after deploy"
# These are older libs that breaks tomcat 7 (added '*' to catch-all)
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/javax.servlet-3.1*.jar
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/javax.servlet-api-3.0*.jar
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/servlet-api-2.5*.jar
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/jsp-api-2.1*.jar

echo "...modifying rya web config (environment.properties)"
cat > ${WEBAPPS_DIR}/web.rya/WEB-INF/classes/environment.properties <<EOF
instance.name=dev
instance.zk=localhost:2181
instance.username=root
instance.password=root
rya.tableprefix=rya_
rya.displayqueryplan=true
EOF

echo "Rya web accessible from host at http://localhost:8080/web.rya/sparqlQuery.jsp"

echo "operation finished."
