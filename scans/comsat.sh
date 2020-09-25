#!/bin/bash
# Takes screenshots of webservers of selected targets

set -e

source "$HOME/.recon-scripts/includes/init.sh"

if [ -z $SELECTED_TARGETS ]; then
    echo ""
    echo -e "${Red} Target(s) in $TARGETS_DIR must be provided${Reset}"
    exit 0
fi

for target in $SELECTED_TARGETS; do
    target_dir="$TARGETS_DIR/$target"

    probe_subdomains $target_dir
    take_screenshots $target_dir
done
find . -size 0 -delete
