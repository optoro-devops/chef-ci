#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

cd $WORKSPACE/repo
rvm use 2.1.2
bundle exec berks up
if [ $? == 0 ];
then
  VERSION=`cat $WORKSPACE/repo/metadata.rb | grep -m1 version | sed 's/'\''//g' | awk '{print "v"$2}'`
  COOKBOOK=`cat $WORKSPACE/repo/metadata.rb | grep -m1 name | sed 's/'\''//g' | cut -d ' ' -f2`
  # Write log to Elasticsearch via logstash for Grafana annotations
  LOG="{ \"type\": \"chef-deploy\", \"cookbook\": \"${COOKBOOK}\", \"version\": \"${VERSION}\", \"cookbook-and-version\": \"${COOKBOOK} - ${VERSION}\" }"
  echo "Writing to Logstash: ${LOG}"
  echo $LOG | nc -q1 -u 127.0.0.1 5228
fi
