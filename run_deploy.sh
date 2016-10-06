#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)
COOKBOOK=`cat $WORKSPACE/repo/metadata.rb | grep -m1 name | sed 's/'\''//g' | cut -d ' ' -f2`

# Create environment
$DIR/set_env.sh

cd $WORKSPACE/repo
if [ -d /usr/local/rvm ]
then
  rvm use 2.2.4
fi

bundle exec berks up
if [ $? == 0 ];
then
  VERSION=`cat $WORKSPACE/repo/metadata.rb | grep -m1 version | sed 's/'\''//g' | awk '{print "v"$2}'`
  # Write log to Elasticsearch via logstash for Grafana annotations
  LOG="{ \"type\": \"chef-deploy\", \"cookbook\": \"${COOKBOOK}\", \"version\": \"${VERSION}\", \"cookbook-and-version\": \"${COOKBOOK} - ${VERSION}\" }"
  echo "Writing to Logstash: ${LOG}"
  echo $LOG | nc -q1 -u 127.0.0.1 5228
fi

if [[ $COOKBOOK == optoro_* ]];
then
  bundle exec knife supermarket share -m 'https://supermarket.optoro.io' -o '.' $COOKBOOK 
fi
