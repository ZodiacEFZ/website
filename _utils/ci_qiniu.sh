#!/bin/bash
set -e
cd "${0%/*}"

if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    exit 0
fi

wget http://devtools.qiniu.com/qshell-v1.8.0.zip
unzip qshell-v1.8.0.zip
cp qshell_linux_amd64 qshell
