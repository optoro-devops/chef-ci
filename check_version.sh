#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Build ssh script for git
$DIR/build_ssh.sh

# Outputs integer based on version 'v2.0.0' or '2.0.0'.
# Above would output 2000
function real_version {
  local version=$1
  version=$(echo $version | sed 's/v*\(.*\)$/\1/' | awk -F . '{ version = ($1*1000) + ($2*100) + $3; print version }')
  echo $version
}

export TAG=`cat $WORKSPACE/repo/metadata.rb | grep -m1 version | sed 's/'\''//g' | awk '{print "v"$2}'`
for x in $(git ls-remote --tags --exit-code origin | awk '{print $2}' | sed 's/refs\/tags\/\(v.*\)$/\1/'); do 
  if [[ $(real_version $TAG) -le $(real_version $x) ]]; then
    echo "ERROR: ${TAG} has already been used or is less than the current version";
    exit 1;
  fi;
done
