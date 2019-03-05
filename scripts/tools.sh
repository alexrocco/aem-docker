#!/bin/bash

start_aem() {
  echo "Starting AEM..."
  /crx/$1/crx-quickstart/bin/start &> /dev/null &
}

stop_aem() {
  echo "Stopping AEM..."
  /crx/$1/crx-quickstart/bin/stop
}

wait_aem_start() {
  echo "Waiting for localhost:${HTTP_PORT} to become available"
  while [ "$(curl -s -o /dev/null -I -w "%{http_code}" http://localhost:$1/libs/granite/core/content/login.html)" -ne '200' ]
  do
    echo -ne "."
    sleep 3
  done
  echo -e "\nAEM started.\n"
}

wait_aem_stop() {
  echo "Stopping AEM..."
  while [ -n "$(curl -Is http://localhost:$1 | head -n 1)" ]
  do
    echo -ne "."
    sleep 3
  done
  echo -e "\nAEM stopped.\n"
}
