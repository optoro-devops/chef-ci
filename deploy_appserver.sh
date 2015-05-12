#!/bin/bash --login

# get the environment of nodes we want to work with
environment=$1
tag=$2
action=$3

rvm use system

if [ -n "$action" ]; then
  for node in `knife search node "chef_environment:$environment AND tags:$tag" -i -F text | egrep -v "items found|^$"`; do
    echo "setting action to $action for node: $node..."
    knife set_attribute node $node one_time_action $action
  done
fi

echo "beginning $action for nodes..."
knife job start 'chef-client' --search "chef_environment:$environment AND tags:$tag"
