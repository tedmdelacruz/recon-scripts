#!/bin/bash
# Initial scan for all targets in the targets directory
# Populates the following:
# - subdomains.txt
# - webservers.txt
# - urls.txt

set -e

source "$HOME/.recon-scripts/includes/init.sh"

cd $TARGETS_DIR
for target in *; do 
    [[ -d $target ]] || continue
    target_dir="$TARGETS_DIR/$target"

    enumerate_subdomains $target_dir
    probe_subdomains $target_dir
    crawl_urls $target_dir
    notify_general ":satellite_antenna: Done sweeping target: $target"
    delete_empty_files $target_dir
done
