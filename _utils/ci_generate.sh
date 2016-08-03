#!/bin/bash
cd "${0%/*}"

envsubst < "test.json"
envsubst < "sync.template.json" > "sync.json"
