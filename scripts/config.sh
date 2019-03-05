#!/bin/bash

source /tmp/tools.sh

echo "Unpacking AEM"
java -jar /crx/${AEM_RUNMODE}/cq-quickstart-${AEM_VERSION}.jar -unpack -r ${AEM_RUNMODE}

echo "Overriding AEM start file"
# Overrinding these configs on start script to not use a specific file for author or publish
sed -i "s/AEM_RUNMODE/${AEM_RUNMODE}/g; s/HTTP_PORT/${HTTP_PORT}/g; s/HTTP_DEBUG_PORT/${DEBUG_HTTP_PORT}/g;" /tmp/start
mv /tmp/start /crx/${AEM_RUNMODE}/crx-quickstart/bin/
chmod +x /crx/${AEM_RUNMODE}/crx-quickstart/bin/start

start_aem $AEM_RUNMODE
wait_aem_start $HTTP_PORT

# AEM was created with 'nosamplecontent' (present on start file) and CRX is disable by default using this run mode.
echo "Enabling CRX"
curl -s -u admin:admin -F "jcr:primaryType=sling:OsgiConfig" -F "alias=/crx/server" -F "dav.create-absolute-uri=true" -F "dav.create-absolute-uri@TypeHint=Boolean" \
  http://localhost:${HTTP_PORT}/apps/system/config/org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet &> /dev/null

stop_aem $AEM_RUNMODE
wait_aem_stop $HTTP_PORT
