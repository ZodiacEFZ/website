#!/bin/bash
set -e
SOURCE_BRANCH="master"

cd "${0%/*}"

if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    exit 0
fi

if [ "$BUILD_TARGET" = "GITHUB_PAGES" ]; then
   ./ci_deploy_github.sh
fi
if [ "$BUILD_TARGET" = "QINIU" ]; then
   ./ci_deploy_qiniu.sh
fi
