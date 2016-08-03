#!/bin/bash
cd "${0%/*}"

envsubst < "sync.template.json" > "sync.json"
