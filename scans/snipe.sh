#!/bin/bash
# Scans a single target in the targets directory

set -e

source "$HOME/.recon-scripts/includes/init.sh"

if [ -z "$SELECTED_TARGETS" ]; then
    echo ""
    echo -e "${Red} Target(s) in $TARGETS_DIR must be provided${Reset}"
    exit 0
fi

for target in $SELECTED_TARGETS; do
    echo -e "$Run Sniping $target..."
    target_dir="$TARGETS_DIR/$target"

    enumerate_subdomains $target_dir
    probe_subdomains $target_dir
    cloud_bucket_enum $target_dir
    crawl_urls $target_dir
    crawl_js $target_dir
    xss_basic $target_dir
    take_screenshots $target_dir
done
find . -size 0 -delete
