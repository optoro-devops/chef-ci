#!/bin/bash --login

# Build shell script for calling when pushing to git repo
echo '#!/bin/sh' > $WORKSPACE/ssh.sh
echo 'exec ssh -i ~jenkins/.ssh/id_rsa -l smedefind $@' >> $WORKSPACE/ssh.sh
chmod +x $WORKSPACE/ssh.sh
cd $WORKSPACE/repo
export GIT_SSH="$WORKSPACE/ssh.sh"
