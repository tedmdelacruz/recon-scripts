#!/usr/bin/env bash

set -e

work_dir=$(dirname $0)
source "$work_dir/../includes/vars.sh"
source "$work_dir/../includes/functions.sh"

target_dir=$1

if [[ ! -d $1 ]]; then
    echo "$1 is not a valid directory"
    exit 0
fi

domains_file="$1/domains.txt"
if [[ ! -f $domains_file ]]; then
    echo "domains.txt not found in $1"
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
take_screenshots $target_dir

echo ""
echo "Done."
