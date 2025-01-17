#!/bin/bash
# usage: git clone https://github.com/OhadRubin/useful_scripts.git
#        GITHUB_ACCESS_TOKEN= ... bash useful_scripts/setup_repos.sh repo1 repo2 ... [--setup repo1 repo2 ...]

wget -qO- https://gist.githubusercontent.com/OhadRubin/0566552ea515d01a8da7883a8bc65af2/raw/033f2deacd5731b7f80adc88c52148a4d4fc0327/load_api_keys.sh | bash -s -- $GITHUB_ACCESS_TOKEN > ~/.env
source ~/.env
cat ~/.env > ~/.bashrc
bash useful_scripts/gcs_fuse_install.sh
bash useful_scripts/setup_doc_ker.sh


if [ $# -eq 0 ]; then
    echo "Usage: $0 repo1 repo2 ... [--setup repo1 repo2 ...]"
    echo "Example: $0 HemELM vllm --setup HemELM"
    echo "         This will clone both repos but only run setup.sh for HemELM"
    echo "         Without --setup, repos will only be cloned without running setup.sh"
    exit 1
fi

# Parse arguments
REPOS=()
SETUP_REPOS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --setup)
            shift
            while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                SETUP_REPOS+=("$1")
                shift
            done
            ;;
        *)
            REPOS+=("$1")
            shift
            ;;
    esac
done
for repo in ${REPOS[@]}; do
    cd ~
    git clone https://OhadRubin:$GITHUB_ACCESS_TOKEN@github.com/OhadRubin/$repo.git
    cd $repo
    if [[ " ${SETUP_REPOS[@]} " =~ " ${repo} " ]]; then
        bash setup.sh
    fi
done
