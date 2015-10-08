#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

cd $WORKSPACE/repo
rvm use 2.1.2
if [ -f $WORKSPACE/repo/Thorfile ]; then
  bundle exec thor test:foodcritic
else
  bundle exec strainer test --only foodcritic
fi
