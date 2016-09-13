#! /usr/bin/env bash

# this may not be necessary, just don't want to get rid of it.

if [ ! -f ${APP_ROOT}/scripts/.tomcat_admin_created ]; then
    #generate password
    PASS=${TOMCAT_PASS:-$(cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w 10| head -n 1)}
    _word=$( [ ${TOMCAT_PASS} ] && echo "preset" || echo "random" )

    echo "=> Creating and admin user with a ${_word} password in Tomcat"
    sed -i -r 's/<\/tomcat-users>//' ${CATALINA_HOME}/conf/tomcat-users.xml
    echo '<role rolename="manager-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
    echo '<role rolename="manager-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
    echo '<role rolename="manager-jmx"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
    echo '<role rolename="admin-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
    echo '<role rolename="admin-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
    echo "<user username=\"admin\" password=\"${PASS}\" roles=\"manager-gui,manager-script,manager-jmx,admin-gui, admin-script\"/>" >> ${CATALINA_HOME}/conf/tomcat-users.xml
    echo '</tomcat-users>' >> ${CATALINA_HOME}/conf/tomcat-users.xml 
    echo "=> Done!"
    touch ${APP_ROOT}/scripts/.tomcat_admin_created
    # adding actual password to .tomcat_admin_created
    echo "admin:${PASS}" >> ${APP_ROOT}/scripts/.tomcat_admin_created 
    echo "========================================================================"
    echo "You can now configure to this Tomcat server using:"
    echo ""
    echo "    admin:${PASS}"
    echo ""
    echo "========================================================================"
fi
