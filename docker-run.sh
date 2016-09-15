#!/bin/bash

# CATALINA_BASE and CATALINA_HOME are `/usr/local/tomcat/`
# APP_ROOT `is /opt`
# ADDING .m2 for cross-pollenation if snapshot updates need to be built.
# ADDING PATH TO RYA-CLIENT (assumes locally cloned and a peer to this repo)
# ADDING THE FULL ENTRYPOINT AT RUNTIME (PLUS ALL SCRIPTS FROM 'container_scripts')
docker run --rm -it \
 --ulimit nofile=9999:9999 \
 -v "$(pwd)/app_root":/opt \
 -v "$(pwd)/webapps":/usr/local/tomcat/webapps \
 -v "$HOME/.m2":/root/.m2 \
 -v "$(realpath $(dirname $(pwd)))/incubator-rya":/usr/local/src/incubator-rya \
 -v "$(pwd)/container_scripts/app_root/stop_services.sh":/opt/stop_services.sh \
 -v "$(pwd)/container_scripts/app_root/restart_services.sh":/opt/restart_services.sh \
 -v "$(pwd)/container_scripts/src_mgr/build_rya.sh":/usr/local/src/build_rya.sh \
 -v "$(pwd)/container_scripts/src_mgr/deploy_rya.sh":/usr/local/src/deploy_rya.sh \
 -v "$(pwd)/container_scripts/src_mgr/remove_rya_conflicts.sh":/usr/local/src/remove_rya_conflicts.sh \
 -v "$(pwd)/container_scripts/entrypoint.sh.master":/entrypoint.sh \
 -p 8080:8080 \
 -h rya-example-box \
 --add-host zoo1:127.0.0.1 \
 --add-host zoo2:127.0.0.1 \
 --add-host zoo3:127.0.0.1 \
 --name ryacc \
local/rya
