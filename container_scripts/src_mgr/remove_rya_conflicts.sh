#!/bin/bash

#just in case, source environment
source /opt/.accumulo_rc.sh

echo "...removing conflicting openrdf jars after deploy"
# These are older libs that breaks tomcat 7
rm -f ${WEBAPPS_DIR}/openrdf-workbench/WEB-INF/lib/servlet-api-2.5*.jar
rm -f ${WEBAPPS_DIR}/openrdf-workbench/WEB-INF/lib/jsp-api-2.1*.jar
rm -f ${WEBAPPS_DIR}/openrdf-sesame/WEB-INF/lib/servlet-api-2.5*.jar
rm -f ${WEBAPPS_DIR}/openrdf-sesame/WEB-INF/lib/jsp-api-2.1*.jar

echo "...removing conflicting rya.web jars after deploy"
# These are older libs that breaks tomcat 7 (added '*' to catch-all)
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/javax.servlet-3.1*.jar
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/javax.servlet-api-3.0*.jar
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/servlet-api-2.5*.jar
rm -f ${WEBAPPS_DIR}/web.rya/WEB-INF/lib/jsp-api-2.1*.jar

