#!/usr/bin/env bash
# @TODO Check VCS leaks using githound
# @TODO Show github dork links
# @TODO Allow threading using interlace

set -e

work_dir=$(dirname $0)
source "$work_dir/variables.sh"
source "$work_dir/functions.sh"

target_dir=$1

usage(){
    cat <<EOF
Manual reconnaisance tool that does the following to domains in a target:
- Enumerate subdomains using sublist3r
- Show GitHub dorking links @TODO
- Scan using Subdomainizer
- Probe subdomains using httpx
- Check cloud buckets using cloud_enum and S3scanner
- Check VCS leaks using githound @TODO
- Scan webpages using nuclei
- Take screenshots using aquatone

Usage: ./recon.sh path/to/target_dir

- target_dir requires a domains.txt file
EOF
    exit 1
}

if [[ -z $1 ]]; then
    usage 
fi

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
