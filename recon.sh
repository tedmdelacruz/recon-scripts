#!/usr/bin/env bash
# @TODO Check VCS leaks using githound
# @TODO Show github dork links
# @TODO Allow threading using interlace

set -e

source ./paths.sh

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

enumerate_subdomains(){
    echo "Enumerating subdomains using Sublist3r..."
    python3 $SUBLIST3R_PATH -v -d $1 -p 80,443,21,22 -o "$2/sublist3r.txt"
    echo "Enumerating subdomains using SubDomainizer..."
    python3 $SUBDOMAINIZER_PATH -u $1 -o "$2/subdomainizer.txt"
}

probe_subdomains(){
    echo "Probing subdomains using httpx..."
    httpx -verbose -l "$1/subdomains.txt" -o "$1/httpx.txt"
}

cloud_bucket_enum(){
    echo "Checking cloud buckets using cloud_enum..."
    python3 $CLOUD_ENUM_PATH -kf "$1/subdomains.txt" -l "$1/cloud_enum.txt"
    echo "Checking S3 buckets using S3Scanner..."
    python3 $S3SANNER_PATH -kf "$1/subdomains.txt" -o "$1/s3_scan.txt"
}

nuclei_scan(){
    nuclei_dir="$target_dir/nuclei"
    if [[ ! -d $nuclei_dir ]]; then
        mkdir $nuclei_dir
    fi
    echo "Scanning for low-hanging fruits using nuclei..."
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/cve" -o "$nuclei_dir/cve.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/subdomain-takeover" -o "$nuclei_dir/subdomain-takeover.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/default-credentials" -o "$nuclei_dir/default-credentials.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/generic-detections" -o "$nuclei_dir/generic-detections.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/dns" -o "$nuclei_dir/dns.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/files" -o "$nuclei_dir/files.txt"
}

take_screenshots(){
    screenshots_dir="$target_dir/screenshots"
    if [[ ! -d $screenshots_dir ]]; then
        mkdir $screenshots_dir
    fi
    echo "Taking screenshots..."
    cat $1 | aquatone -debug -ports=80,443 -resolution=800,600 -chrome-path=$CHROME_PATH -out $screenshots_dir
}

while IFS= read -r domain; do
    [[ ! -z $domain ]] || continue
    enumerate_subdomains $domain $target_dir
done < "$domains_file"

probe_subdomains $target_dir
cloud_bucket_enum $target_dir
nuclei_scan $target_dir
take_screenshots $target_dir

echo ""
echo "Done."
