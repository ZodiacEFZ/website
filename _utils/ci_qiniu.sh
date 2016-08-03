#!/bin/bash
set -e
cd "${0%/*}"

wget http://devtools.qiniu.com/qshell-v1.8.0.zip
unzip qshell-v1.8.0.zip
cp qshell_linux_amd64 qshell
