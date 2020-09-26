#!/bin/bash
# Crawls URLs and JS of selected targets

set -e

source "$HOME/.recon-scripts/includes/init.sh"

if [ -z "$SELECTED_TARGETS" ]; then
    echo ""
    echo -e "${Red} Target(s) in $TARGETS_DIR must be provided${Reset}"
    exit 0
fi

for target in $SELECTED_TARGETS; do
    target_dir="$TARGETS_DIR/$target"

    enumerate_subdomains $target_dir
    probe_subdomains $target_dir
    crawl_urls $target_dir
    crawl_js $target_dir
    notify_general "Done crawling target: $target"
done
find . -size 0 -delete
