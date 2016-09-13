#! /usr/bin/env bash

# CATALINA_BASE and CATALINA_HOME are `/usr/local/tomcat/`
# APP_ROOT `is /opt`
# ADDING THE FULL ENTRYPOINT AT RUNTIME
docker run --rm -it \
 --ulimit nofile=9999:9999 \
 -v "$(pwd)/app_root":/opt \
 -v "$(pwd)/stop_services.sh":/opt/stop_services.sh \
 -v "$(pwd)/webapps":/usr/local/tomcat/webapps \
 -v "$(pwd)/entrypoint.sh.master":/entrypoint.sh \
 -p 2181:2181 \
 -p 50095:50095 \
 -p 8080:8080 \
 -h rya-example-box \
 --add-host zoo1:127.0.0.1 \
 --add-host zoo2:127.0.0.1 \
 --add-host zoo3:127.0.0.1 \
 --name ryacc \
local/rya
