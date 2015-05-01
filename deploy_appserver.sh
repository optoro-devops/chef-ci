#!/bin/bash --login

# get the environment of nodes we want to work with
environment=$1

# allow a specific pattern to be passed in for node matching, but default to nodes with app if nothing is passed in
if [ -z "$2" ]; then
  node_pattern="*app*"
else
  node_pattern=$2
fi

rvm use system
knife job start 'chef-client' --search "name:$node_pattern AND chef_environment:$environment"
