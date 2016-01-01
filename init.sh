#!/bin/bash

source ~/.nvm/nvm.sh

if [ ! -d /workspace/.c9 ]; then
	mkdir -p /workspace/.c9
fi

if [ ! -f /workspace/.c9/project.settings ]; then
	cp /settings-project /workspace/.c9/project.settings
fi

if [ ! -f /workspace/.c9/state.settings ]; then
	cp /settings-state /workspace/.c9/state.settings
fi

cd /c9sdk
node server.js -p 8080 -l 0.0.0.0 -w /workspace -a :
