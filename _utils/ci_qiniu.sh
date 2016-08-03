wget http://devtools.qiniu.com/qshell-v1.8.0.zip
unzip qshell-v1.8.0.zip
cp qshell_linux_amd64 qshell

envsubst < "sync.template.json" > "sync.json"
