#!/bin/bash

if [ ! -d /workspace/.c9 ]; then
	mkdir -p /workspace/.c9
fi

if [ ! -f /workspace/.c9/project.settings ]; then
	cp /settings-project /workspace/.c9/project.settings
fi

if [ ! -f /workspace/.c9/state.settings ]; then
	cp /settings-state /workspace/.c9/state.settings
fi

dockerize -template /run-c9.sh.tpl > /run-c9.sh
chmod +x /run-c9.sh
/run-c9.sh
