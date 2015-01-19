#!/bin/bash --login

# Build ssh script for git
DIR=$(cd $(dirname "$0"); pwd)
$DIR/build_ssh.sh

cd $WORKSPACE/repo
export TAG=`cat $WORKSPACE/repo/metadata.rb | grep -m1 version | sed 's/'\''//g' | awk '{print "v"$2}'`
git tag $TAG
git push origin $TAG
