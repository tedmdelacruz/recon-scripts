#!/bin/bash
# Crawls all targets in the targets directory
# and scans each target for basic XSS.
# Also notifies for any changes in JS URLs

set -e

source "$HOME/.recon-scripts/includes/init.sh"

cd $TARGETS_DIR
for target in *; do 
    [[ -d $target ]] || continue
    target_dir="$TARGETS_DIR/$target"

    crawl_urls $target_dir
    xss_basic $target_dir
    notify_xss $target_dir "basic_xss" $SLACK_ALERT_XSS_CHANNEL_ID
    notify_xss $target_dir "top_15_xss" $SLACK_ALERT_XSS_CHANNEL_ID
    crawl_js $target_dir
    notify_changes $target_dir "js" $SLACK_ALERT_JS_FILES_CHANNEL_ID
done
find . -size 0 -delete
