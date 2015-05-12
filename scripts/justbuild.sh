#!/bin/sh -ex

# BRANCH_TO_BUILD should be set
if [ -z "$BRANCH_TO_BUILD" ]; then
  echo "BRANCH_TO_BUILD has not been set. Please specify it"
  exit 1
fi

if [ `ant -version | awk '{print $4}'` != "1.9.4" ]; then
  echo "We need ant version 1.9.4 to build Zookeeper";
  exit 2
fi

# If the branch_to_build is a release tag, then create an altiscale branch.
# Also check if other altiscale branches have patches that have not yet been merged.
# WILL DO LATER

#Checkout the right branch
git checkout $BRANCH_TO_BUILD
git reset --hard
git clean -fdx

# We can use different commands for building different versions
if [ "$BRANCH_TO_BUILD" == "someBranch" ]; then
  echo "Building branch someBranch"
else
  # By default use these commands for building
  ant package-native
  ant tar
fi
