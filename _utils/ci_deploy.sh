#!/bin/bash
set -e
SOURCE_BRANCH="master"

cd "${0%/*}"

cp -a ../_icon/. ../_site/


if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    exit 0
fi

./ci_deploy_qiniu.sh
./ci_deploy_github.sh
