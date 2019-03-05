#!/bin/bash

source /tmp/tools.sh

start_aem $AEM_RUNMODE
wait_aem_start $HTTP_PORT

echo "Installing Adobe AEM Service Pack"
curl -s -o /dev/null -u admin:admin -F file=@"/tmp/aem-service-pkg-${SERVICE_PACKAGE_VERSION}.zip" -F force=true -F install=true \
  http://localhost:$HTTP_PORT/crx/packmgr/service.jsp

echo "Waiting Service Package to start installation"
sleep 60

echo "Wait AEM to start after installing"
wait_aem_start $HTTP_PORT

stop_aem $AEM_RUNMODE
wait_aem_stop $HTTP_PORT
