#!/bin/bash

source ~/.bashrc
git clone https://github.com/OhadRubin/useful_scripts.git
bash useful_scripts/gcs_fuse_install.sh
bash useful_scripts/setup_doc_ker.sh
git clone https://github.com/OhadRubin/vllm.git
export GITHUB_ACCESS_TOKEN=$(bash -ic 'source ~/.bashrc; echo $GITHUB_ACCESS_TOKEN')
cd ~
git clone https://OhadRubin:$GITHUB_ACCESS_TOKEN@github.com/OhadRubin/HemELM.git