#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Build ssh script for git
$DIR/build_ssh.sh

cd $WORKSPACE/repo

$DIR/check_version.sh
rbenv local 2.1.2
bundle install --path ~jenkins/vendor/bundle --jobs 4 --retry 3
bundle exec berks install
bundle exec strainer test --fail-fast
