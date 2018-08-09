#!/bin/bash
set -e # Exit with nonzero exit code if anything fails
cd "${0%/*}"

bundle exec jekyll build --config _config.$BUILD_TARGET.yml,_config.yml
