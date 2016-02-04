#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Start the ssh agent. Evaling the output will set the relevant environment
# variables
eval `ssh-agent`

# Add the default keys like id_rsa and id_dsa (or explicitly specify your key,
# if it's not a default)
ssh-add ~jenkins/.ssh/joyent.pem

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
rvm use 2.2.2
gem install kitchen-joyent
if [ -f Thorfile ]; then
  bundle exec thor test:kitchen
else
  bundle exec strainer test --only kitchen
fi

# Save the return value of your script
RETVAL=$?

# Clean up
kill $SSH_AGENT_PID

# Exit the script with the true return value instead of the return value of kill
# which could be successful even when the build has crashed
exit $RETVAL
