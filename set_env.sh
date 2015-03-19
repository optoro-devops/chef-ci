#!/bin/bash --login
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export KITCHEN_LOCAL_YAML=~jenkins/.kitchen/config.yml
# Configure Berkshelf DepSolver timeout to 600 secs
export SOLVE_TIMEOUT=600
