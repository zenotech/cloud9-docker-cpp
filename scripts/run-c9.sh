#!/bin/bash
source ~/.nvm/nvm.sh
cd /c9sdk
node server.js --collab -p 8080 -l 0.0.0.0 -w /workspace -a {{ .Env.C9_USER }}:{{ .Env.C9_PASSWORD }}
