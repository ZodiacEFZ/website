#!/bin/bash
cd "$(dirname "$0")"

envsubst < "_utils/test.json"
envsubst < "_utils/sync.template.json" > "_utils/sync.json"
