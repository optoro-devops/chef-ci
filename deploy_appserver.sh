#!/bin/bash --login

# get the environment of nodes we want to work with
environment=$1
tag=$2

rvm use system
knife job start 'chef-client' --search "chef_environment:$environment AND tags:$tag"
