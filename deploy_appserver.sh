#!/bin/bash --login

# get the environment of nodes we want to work with
environment=$1
tag=$2
action=$3

if [[ "$action" == "rollback" ]]; then
  for node in `knife search node "chef_environment:$environment AND tags:$tag" -i -F text | egrep -v "items found|^$"`; do
    echo "setting rollback attribute for node: $node..."
    knife set_attribute node $node one_time_action 'rollback'
  done
fi

rvm use system
echo "beginning $action for nodes..."
knife job start 'chef-client' --search "chef_environment:$environment AND tags:$tag"
