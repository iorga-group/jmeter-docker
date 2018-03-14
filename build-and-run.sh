#!/bin/bash

set -x
set -e

cd "$(readlink -f `dirname $0`)"

export JMX_PATH=$1
export RUN_NUMBER=$2

export USER_UID=`id -u`

export JMETER_ARGS=$JMETER_ARGS

# Following performance hints from http://nonfunctionaltestingtools.blogspot.fr/2017/07/linux-tuning-while-running-huge-load.html (in order to avoid "Cannot assign requested address (connect failed)")
echo 1024 65000 | sudo tee /proc/sys/net/ipv4/ip_local_port_range
sudo sysctl -w net.ipv4.tcp_tw_recycle=1
sudo sysctl -w net.ipv4.tcp_tw_reuse=1

sudo -E docker-compose up --force-recreate --build
