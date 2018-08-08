#!/bin/bash
set -e
cd "${0%/*}"

wget https://github.com/ZodiacEFZ/qshell-dependency/raw/master/qshell-v2.2.0.zip
unzip qshell-v2.2.0.zip
cp qshell-linux-x64 qshell
