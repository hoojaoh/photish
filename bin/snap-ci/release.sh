#!/bin/bash
set -xeuo pipefail

source setup.sh

# map values from snap-ci
export COMMIT=$SNAP_COMMIT
export BRANCH=$SNAP_BRANCH

# conditionally release app
if git describe --exact-match $COMMIT && [ $BRANCH = 'master' ]
then
  bundle exec rake build release:rubygem_push
else
  echo "This is not a tagged commit, skipping release."
fi