#!/usr/bin/env bash

set -e

TARGETS_DIR=$1
if [ ! -d "$TARGETS_DIR" ]; then
    echo "Directory '$TARGETS_DIR' does not exist"
    exit 0
fi

echo "Targets directory: $TARGETS_DIR"
echo "Targets found:"
echo "$(ls $TARGETS_DIR)"

cd $TARGETS_DIR

for target in *; do 
    [[ -d $target ]] || continue
    target_dir="$TARGETS_DIR/$target"
    if [[ ! -f "$target_dir/httpx.txt" ]]; then
        probe_subdomains $target_dir
    fi
    crawl_urls $target_dir
    xss_scan $target_dir
    notify_xss $target_dir "basic_xss" $SLACK_ALERT_XSS_CHANNEL_ID
    notify_xss $target_dir "top_15_xss" $SLACK_ALERT_XSS_CHANNEL_ID
    crawl_js $target_dir
    notify_changes $target_dir "js" $SLACK_ALERT_JS_FILES_CHANNEL_ID
done

echo ""
echo "Done."
