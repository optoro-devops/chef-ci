#!/bin/bash --login
DIR=$(cd $(dirname "$0"); pwd)

# Create environment
$DIR/set_env.sh

cd $WORKSPACE/repo
rvm use 2.2.4
grep -s "'foodcritic-rules-optoro'" Gemfile
if [ $? -ne 0 ]
then
  echo -e "ERROR: You need to add foodcritic-rules-optoro to your Gemfile\n\t gem 'foodcritic-rules-optoro'"
  exit 1
fi
if [ -f Thorfile ]; then
  bundle exec foodcritic -f any -B ./ -G
else
  bundle exec strainer test --only foodcritic
fi
