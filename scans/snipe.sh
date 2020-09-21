#!/usr/bin/env bash
# Scans a single target in the targets directory

set -e

work_dir=$(dirname $0)
source "$work_dir/../includes/vars.sh"
source "$work_dir/../includes/functions.sh"

if [[ ! -d $1 ]]; then
    echo "$1 is not a valid directory"
    exit 0
fi
TARGET_DIR=$1

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
xss_strike $TARGET_DIR
cloud_bucket_enum $TARGET_DIR
git_hound $TARGET_DIR
crawl_urls $TARGET_DIR
crawl_js $TARGET_DIR
nuclei_scan $TARGET_DIR
take_screenshots $TARGET_DIR

echo ""
echo "Done."
