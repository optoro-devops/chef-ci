#!/bin/bash --login
set -o pipefail
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

# Build ssh script for git
$DIR/build_ssh.sh

cd $WORKSPACE/repo

$DIR/check_version.sh

# Set kitchen's override config
export KITCHEN_LOCAL_YAML=~jenkins/.kitchen/config.yml
# Configure Berkshelf DepSolver timeout to 600 secs
export SOLVE_TIMEOUT=600

rvm use 2.1.2
bundle install --path ~jenkins/vendor/bundle --jobs 4 --retry 3
bundle exec berks install
bundle exec strainer test --fail-fast | tee $WORKSPACE/log
STRAINER_EXIT=$?
cat $WORKSPACE/log | grep chefspec >> $WORKSPACE/comments
LOG_EXIT=$?
if [ $STRAINER_EXIT != 0 ] || [ $LOG_EXIT != 0 ]; then exit 1; fi
