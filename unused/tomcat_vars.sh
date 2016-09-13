#! /usr/bin/env bash

# set provided variables, this doesn't work as-is for tomcat8!!!

if [ -n "${Xmx}" ];
then
        sed -i s/Xmx.*\ /Xmx${Xmx}\ /g /etc/default/tomcat7
fi

if [ -n "${JAVA_OPTS}" ];
then
        # Add any Java opts that are set in the container
        echo "Adding JAVA OPTS"
        echo "JAVA_OPTS=\"\${JAVA_OPTS} ${JAVA_OPTS} \"" >> /etc/default/tomcat7
fi

if [ -n "${JAVA_HOME}" ];
then
	# Add java home if set in container
	echo "Adding JAVA_HOME"
	echo "JAVA_HOME=\"${JAVA_HOME}\"" >> /etc/default/tomcat7
fi
