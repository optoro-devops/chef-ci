#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Force test-kitchen to use config in jenkin's home
# One config to rule them all
export KITCHEN_LOCAL_YAML=~jenkins/.kitchen/config.yml

cd $WORKSPACE/repo
rvm use 2.1.2
if [ -f Thorfile ]; then
  bundle exec thor test:kitchen
else
  bundle exec strainer test --only kitchen
fi
