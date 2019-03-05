#!/bin/bash

source /tmp/tools.sh

run_garbage_collection() {
  echo "Run Data Store Garbage Collection"
  curl -s -o /dev/null -u admin:admin -X POST --data 'action=start' \
    "http://localhost:$HTTP_PORT/libs/settings/granite/operations/maintenance/granite_weekly/granite_MongoDataStoreGarbageCollectionTask"

  echo "Waiting Data Store Garbage Collection to run"
  sleep 60
}

start_aem $AEM_RUNMODE
wait_aem_start $HTTP_PORT

echo "Install an empty package on /etc/packages to delete all packages"
curl -s -o /dev/null -u admin:admin -F file=@"/tmp/etc-package.zip" -F force=true -F install=true \
  "http://localhost:$HTTP_PORT/crx/packmgr/service.jsp"

run_garbage_collection

stop_aem $AEM_RUNMODE
wait_aem_stop $HTTP_PORT

start_aem $AEM_RUNMODE
wait_aem_start $HTTP_PORT

run_garbage_collection

stop_aem $AEM_RUNMODE
wait_aem_stop $HTTP_PORT

echo "Run OAK repository optmization"
java -jar /tmp/oak-run.jar checkpoints /crx/$AEM_RUNMODE/crx-quickstart/repository/segmentstore
java -jar /tmp/oak-run.jar checkpoints /crx/$AEM_RUNMODE/crx-quickstart/repository/segmentstore rm-unreferenced
java -jar -Dsun.arch.data.model=32 /tmp/oak-runs.jar compact /crx/$AEM_RUNMODE/crx-quickstart/repository/segmentstore

echo "Remove log files"
rm -rf /crx/$AEM_RUNMODE/crx-quickstart/logs/*
