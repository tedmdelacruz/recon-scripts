#!/usr/bin/env bash

set -e

cli_help(){
    echo "Usage: fleet-amass path/to/targets"
exit 1
}

analyze(){
    echo "[ANALYZING] $1 ..."
    axiom-scan $1 -m=amass -config=amass.ini -o="$2/fleet-amass.txt"
    axiom-scan "$2/fleet-amass.txt" -m=httpx -o="$2/fleet-httpx.txt"
    axiom-scan "$2/fleet-httpx.txt" -m=nuclei -o="$2/fleet-cves.txt"
}

if [ -z $1 ]; then
    cli_help
fi

TARGETS_DIR=$1

if [ ! -d "$TARGETS_DIR" ]; then
    echo "Directory '$TARGETS_DIR' does not exist"
    cli_help
fi

echo "------------------------------"
echo "[TARGETS DIRECTORY] $TARGETS_DIR"
echo "[TARGETS FOUND]"
echo "$(ls $TARGETS_DIR)"
echo "------------------------------"

cd $TARGETS_DIR

axiom-select 'recon*'

# Loop over targets
for target in *; do 
    [ -d $target ] || continue

    domains_file="$TARGETS_DIR/$target/domains.txt"
    if [ ! -f $domains_file ]; then
        echo "$domains_file not found, skipping..."
        echo "------------------------------"
        continue
    fi

    # Run subdomain enumeration
    results_dir="$TARGETS_DIR/$target/fleet-scan"
    if [ ! -d $results_dir ]; then
        mkdir $results_dir
    fi
    analyze $domains_file $results_dir
    echo "------------------------------"
done

echo ""
echo "[DONE]"
