#!/bin/bash --login
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export KITCHEN_LOCAL_YAML=~jenkins/.kitchen/config.yml

# SDC environment variable
export SDC_USER=jenkins
export SDC_KEY_FILE=/mnt/jenkins/.ssh/sdc.pem
export SDC_KEY_ID=20:8f:ca:86:fc:95:d6:52:17:ad:3d:82:41:3f:bf:b8
export SDC_URL=https://api.us-east.optoro.io
