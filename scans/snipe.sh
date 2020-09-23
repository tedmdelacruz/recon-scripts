#!/bin/bash
# Scans a single target in the targets directory

set -e

TARGET_DIR=$1
if [[ -z $TARGET_DIR ]]; then
    echo "A valid directory must be provided"
    exit 0
fi

if [[ ! -d $TARGET_DIR ]]; then
    echo "$TARGET_DIR is not a valid directory"
    exit 0
fi

domains_file="$TARGET_DIR/domains.txt"
if [[ ! -f $domains_file ]]; then
    echo "domains.txt not found in $TARGET_DIR"
    exit 0
fi

while IFS= read -r domain; do
    [[ ! -z $domain ]] || continue
    enumerate_subdomains $domain $TARGET_DIR
done < "$domains_file"

probe_subdomains $TARGET_DIR
cloud_bucket_enum $TARGET_DIR
crawl_urls $TARGET_DIR
crawl_js $TARGET_DIR
nuclei_scan $TARGET_DIR
xss_advanced $TARGET_DIR
take_screenshots $TARGET_DIR

find . -size 0 -delete

echo ""
echo "Done."
