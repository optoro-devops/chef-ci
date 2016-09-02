#!/bin/bash --login
set -o pipefail
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Build ssh script for git
$DIR/build_ssh.sh

cd $WORKSPACE/repo

$DIR/check_version.sh

if [ $? != 0 ]; then exit 1; fi

# Set kitchen's override config
# Precedence:
# 1) KITCHEN_LOCAL_YAML (highest)
# 2) KITCHEN_YAML
# 3) KITCHEN_GLOBAL_YAML (lowest)
export KITCHEN_LOCAL_YAML=$WORKSPACE/repo/.kitchen-override.yml
export KITCHEN_YAML=~jenkins/.kitchen/config_sdc.yml
export KITCHEN_GLOBAL_YAML=$WORKSPACE/repo/.kitchen.yml
# Configure Berkshelf DepSolver timeout to 600 secs
export SOLVE_TIMEOUT=600

if [ -d /usr/local/rvm ]
then
  rvm use 2.2.4
fi

bundle install --path ~jenkins/vendor/bundle --jobs 4 --retry 3
bundle exec berks install
if [ -f Thorfile ]; then
  set -e
  bundle exec foodcritic -f any -B ./ -G
  bundle exec thor test:test | tee $WORKSPACE/log
else
  bundle exec strainer test --fail-fast | tee $WORKSPACE/log
fi
TEST_EXIT=$?
cat $WORKSPACE/log | grep chefspec >> $WORKSPACE/comments
LOG_EXIT=$?
if [ $TEST_EXIT != 0 ] || [ $LOG_EXIT != 0 ]; then exit 1; fi
