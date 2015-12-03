#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

cd $WORKSPACE/repo
rvm use 2.1.2
if [ -f Thorfile ]; then
  bundle exec foodcritic -f any -B ./ -G
else
  bundle exec strainer test --only foodcritic
fi
