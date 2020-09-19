#!/usr/bin/env bash

set -e

cli_help(){
    echo "
Screenshot and analysis script using aquatone

Usage: ./screenshot.sh path/to/targets path/to/chromium [--use-fleet-scan]"
exit 1
}

screenshot(){
    echo "Taking screenshots of $1 ..."
    cat $1 | aquatone -debug -ports=80,443 -resolution=800,600 -chrome-path=$2 -out $3
}

if [[ -z $1 ]]; then
    cli_help
fi

TARGETS_DIR=$1
CHROME_PATH=$2
FLEET_SCAN=$3

if [[ ! -d "$TARGETS_DIR" ]]; then
    echo "Directory '$TARGETS_DIR' does not exist"
    cli_help
fi

if [[ ! $CHROME_PATH ]]; then
    echo "Chrome binary is required"
    cli_help
fi

if [[ ! -f $CHROME_PATH ]]; then
    echo "Chrome binary does not exist"
    cli_help
fi

echo "Targets directory: $TARGETS_DIR"
echo "Chrome binary: $CHROME_PATH"
echo "Targets found:"
echo "$(ls $TARGETS_DIR)"

cd $TARGETS_DIR

# Loop over targets
for target in *; do 
    [[ -d $target ]] || continue

    # Check for http probes list
    if [[ $FLEET_SCAN == "--use-fleet-scan" ]]; then
        httpx_file="$target/fleet-scan/fleet-amass.txt"
    else
        httpx_file="$target/httpx.txt"
    fi
    if [[ ! -f $httpx_file ]]; then
        echo "$httpx_file not found, skipping..."
        continue
    fi

    # Take screenshots
    results_dir="$target/screenshots"
    if [[ ! -d $results_dir ]]; then
        mkdir $results_dir
    fi
    screenshot $probes_file $CHROME_PATH $results_dir
done

echo ""
echo "Done."
