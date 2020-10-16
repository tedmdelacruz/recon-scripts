#!/bin/bash
# Comprehensive scan on all targets in the targets directory

set -e

source "$HOME/.recon-scripts/includes/init.sh"

cd $TARGETS_DIR
for target in *; do 
    [[ -d $target ]] || continue
    target_dir="$TARGETS_DIR/$target"

    enumerate_subdomains $target_dir
    probe_subdomains $target_dir
    crawl_urls $target_dir
    cloud_bucket_enum $target_dir
    dir_brute $target_dir
    nuclei_scan $target_dir
    xss_basic $target_dir
    xss_advanced $target_dir
    notify_general ":boom: Done nuking target: $target"
    delete_empty_files $target_dir
done
