#!/bin/bash
# Scans all targets in the targets directory
# Good for obtaining initial recon against a large number of targets

set -e

source "$HOME/.recon-scripts/includes/init.sh"

cd $TARGETS_DIR
for target in *; do 
    [[ -d $target ]] || continue
    target_dir="$TARGETS_DIR/$target"

    enumerate_subdomains $target_dir
    probe_subdomains $target_dir
    cloud_bucket_enum $target_dir
    crawl_urls $target_dir
    crawl_js $target_dir
    take_screenshots $target_dir
    notify_general "Done sweeping target: $target"
done
find . -size 0 -delete
