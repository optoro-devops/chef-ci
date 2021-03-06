#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Configure Berkshelf DepSolver timeout to 600 secs
export SOLVE_TIMEOUT=600

cd $WORKSPACE/repo

if [ -d /usr/local/rvm ]
then
  rvm use 2.2.4
fi

echo "gem 'knife-supermarket'" >> Gemfile
bundle install --path ~jenkins/vendor/bundle --jobs 4 --retry 3
bundle exec berks install
