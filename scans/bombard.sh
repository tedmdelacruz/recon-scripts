#!/bin/bash
# Comprehensive scan against a target
# Includes a comprehensive nuclei vulnerability scan
# and a XSStrike scan against assets
# Quite noisy, can risk getting IP-blocked by a WAF

set -e

source "$HOME/.recon-scripts/includes/init.sh"

if [ -z $SELECTED_TARGETS ]; then
    echo ""
    echo -e "${Red} Target(s) in $TARGETS_DIR must be provided${Reset}"
    exit 0
fi

for target in $SELECTED_TARGETS; do
    target_dir="$TARGETS_DIR/$target"
    echo -e "$Run Bombarding $target..."

    domains_file="$target_dir/domains.txt"
    if [[ ! -f $domains_file ]]; then
        echo "$Error domains.txt not found in $target_dir${Reset}"
        exit 0
    fi

    while IFS= read -r domain; do
        [[ ! -z $domain ]] || continue
        enumerate_subdomains $domain $target_dir
    done < "$domains_file"

    probe_subdomains $target_dir
    cloud_bucket_enum $target_dir
    crawl_urls $target_dir
    crawl_js $target_dir
    nuclei_scan $target_dir
    xss_advanced $target_dir
    take_screenshots $target_dir
done
find . -size 0 -delete
