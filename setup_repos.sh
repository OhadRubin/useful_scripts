#!/bin/bash
wget -qO- https://gist.githubusercontent.com/OhadRubin/9cd8594e929ec9ccd66c9022c67ea579/raw/a21677d47edf117a45e2a17043bf4bc02ff95d0a/load_api_keys.sh | bash -s -- $GITHUB_ACCESS_TOKEN > ~/.env
source ~/.env
