#!/bin/bash
set -e

cd "${0%/*}"

cp -a ../_icon/. ../_site/

./ci_deploy_qiniu.sh
./ci_deploy_github.sh
