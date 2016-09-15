# rya-docker
Docker quickstart adaptated from Rya VagrantFile [example](https://github.com/apache/incubator-rya/tree/master/extras/vagrantExample/src/main/vagrant).

See [vagrant readme](https://github.com/apache/incubator-rya/blob/master/extras/vagrantExample/src/main/vagrant/readme.md) for more background and usage tips.

## Building
1. build 'local/tomcat' docker images from `./tomcat/docker-build.sh`
2. build 'local/rya' docker images from `./docker-build.sh` (it may ask to wipe folders established after runtime, so pay attention)

## Running
* `./docker-run.sh` will mount host volumes to be populated to save time on subsequent runs (accumulo data folder not added as of yet); it will map ports, set the host name, and name the container _ryacc_.
  * 'entrypoint.sh.master' will replace the placeholder entrypoint. This is where all the artifact management and init occurs.
  * currently artifacts are pulled from a dropbox url (same as the vagrant config); however, if you generate 'app_root' dir (added as a volume in docker-run.sh) and pre-stage artifacts within,the download will be skipped. This approach might be useful to update to more recent snapshots.
  * similar as above, you can generate `webapps' dir and pre-stage artifact 'openrdf-sesame.war' and 'openrdf-workbench.war' within to skip 1x download.
* if you `docker exec` into the running container, you may want to `source ${ACCUMULO_RC}` which should resolve to '${APP_ROOT}/.accumulo_rc.sh' (_APP_ROOT is /opt_)

## Stopping
* since dirs 'app_root' and 'webapps' are persistend between runs, it is best to shutdown cleanly. To do so, run the following from within the container: `.${APP_ROOT}/stop_services.sh`
* then exit the container, may see `Are you sure? this will kill the container. use Ctrl+p, Ctrl+q to detach or Ctrl+d to exit`

## Update and Deploy Rya
* 'docker-run.sh' supports mounting a host controlled git repo for 'incubator-rya' (assumes peer)
* from within the container can run `./build.rya.sh` to build the install the latest artifacts to '.m2' mounted through to the host from 'docker-run.sh'
  * may need to run `./m2_chown.sh` to retake ownership of additions from within the container (after container is stopped)
* run `./deploy_rya.sh` within '$SOURCE_ROOT' (resolves to '/usr/local/src') to update tomcat (while running) with the latest web.rya, handling the same setup steps as in 'entrypoint.sh.master'


