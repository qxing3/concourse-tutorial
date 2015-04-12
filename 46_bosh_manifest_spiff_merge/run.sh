#!/bin/bash

stub=$1; shift
stage=$1; shift

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export ATC_URL=${ATC_URL:-"http://192.168.100.4:8080"}
echo "Tutorial $(basename $DIR)"
echo "Concourse API $ATC_URL"

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
  echo "USAGE: run.sh path/to/stub.yml [show|save]"
  exit 1
}

if [[ "${stub}X" == "X" ]]; then
  usage
fi
stub=$(realpath $stub)
if [[ ! -f ${stub} ]]; then
  usage
fi

if [[ "${stage}" != "show" && "${stage}" != "save" ]]; then
  usage
fi

pushd $DIR
  spiff merge templates/pipeline-final.yml templates/pipeline-base-${stage}.yml ${stub} > pipeline.yml
  yes y | fly configure -c pipeline.yml
  curl $ATC_URL/jobs/job-spiff-merge/builds -X POST
  fly watch -j job-spiff-merge
popd