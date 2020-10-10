#!/bin/bash
# Checks for GitHub leaks and vulnerable cloud buckets of selected targets

set -e

source "$HOME/.recon-scripts/includes/init.sh"

if [ -z "$SELECTED_TARGETS"  ]; then
    echo ""
    echo -e "${Red} Target(s) in $TARGETS_DIR must be provided${Reset}"
    exit 0
fi

for target in $SELECTED_TARGETS; do
    target_dir="$TARGETS_DIR/$target"

    cloud_bucket_enum $target_dir
    git_scan $target_dir
    notify_general ":recycle: Done dumpster diving on target: $target"
done
