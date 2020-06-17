#!/usr/bin/env bash
function build() {
  local image=$1
  docker build -t $image -f Dockerfile .
}

function buildAll() {
  local group=$1
  docker build --tag="$group/jmeter-base:latest" -f Dockerfile .
  docker build --tag="$group/jmeter-master:latest" -f Dockerfile-master .
  docker build --tag="$group/jmeter-slave:latest" -f Dockerfile-slave .
}
function push(){
  docker login
  docker push gabrielstar/jmeter-base
  docker push gabrielstar/jmeter-master
  docker push gabrielstar/jmeter-slave
}
#sh build.sh jmeter-chrome-selenium
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  buildAll gabrielstar && push
fi
