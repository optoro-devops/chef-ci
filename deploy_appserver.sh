#!/usr/bin/env ruby

# get the environment of nodes we want to work with
environment = ARGV.shift

# allow a specific pattern to be passed in for node matching, but default to nodes with app if nothing is passed in
node_pattern = ARGV.shift || "*app*"

`knife job start 'chef-client' --search 'name:#{node_pattern} AND chef_environment:#{environment}'`
