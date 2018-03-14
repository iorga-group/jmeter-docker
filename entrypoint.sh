#!/bin/bash
# Inspired from https://github.com/hhcordero/docker-jmeter-client
# Basically runs jmeter, assuming the PATH is set to point to JMeter bin-dir (see Dockerfile)
#
# This script expects the standdard JMeter command parameters.
#
set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*7))
x=$(($freeMem/10*7))
n=$(($freeMem/10*2))
export JVM_ARGS=${JVM_ARGS:--XX:+UseG1GC -XX:MaxGCPauseMillis=300 -Xmn${n}m -Xms${s}m -Xmx${x}m}

echo "Launching JMeter ${JMETER_VERSION} Docker image on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "Container args=$@"

set -x
exec "$@"
set +x

echo "END Running Jmeter Docker image on `date`"

