#!/bin/bash

set -x
set -e

cd "$(readlink -f `dirname $0`)"

export JMX_PATH=$1
export RUN_NUMBER=$2

export USER_UID=`id -u`

sudo -E docker-compose up --force-recreate --build
