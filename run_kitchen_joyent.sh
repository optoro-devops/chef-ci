#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Force test-kitchen to use config in jenkin's home
# One config to rule them all
# Precedence:
# 1) KITCHEN_LOCAL_YAML (highest)
# 2) KITCHEN_YAML
# 3) KITCHEN_GLOBAL_YAML (lowest)
export KITCHEN_LOCAL_YAML=$WORKSPACE/repo/.kitchen-override.yml
export KITCHEN_YAML=~jenkins/.kitchen/config_joyent.yml
export KITCHEN_GLOBAL_YAML=$WORKSPACE/repo/.kitchen.yml

cd $WORKSPACE/repo
if [ -d /usr/local/rvm ]
then
  rvm use 2.2.4
fi

if ! grep -q "kitchen-joyent" Gemfile
then
  echo "gem 'kitchen-joyent', '~> 0.2.2'" >> Gemfile
  bundle install
fi

if [ -f Thorfile ]; then
  bundle exec thor test:kitchen
else
  bundle exec strainer test --only kitchen
fi
