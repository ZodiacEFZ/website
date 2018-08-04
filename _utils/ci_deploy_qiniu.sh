#!/bin/bash
set -e # Exit with nonzero exit code if anything fails
cd "${0%/*}"

./ci_qiniu.sh
./qshell account $QINIU_ACCESSKEY $QINIU_SECRETKEY
./qshell qupload 4 sync.json
