#!/bin/bash
set -e # Exit with nonzero exit code if anything fails
cd "${0%/*}"

cp -a ./html/. ../_site/
cp -a ../_icon/. ../_site/
