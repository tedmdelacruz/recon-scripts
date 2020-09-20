#!/usr/bin/env bash

set -e

source ../paths.sh

cli_help(){
    echo "Usage: ./cloud_enum.sh path/to/targets"
exit 1
}

cloud_enum(){
    subdomains_file="$1/subdomains.txt"
    if [ ! -f $subdomains_file ]; then
        echo "$subdomains_file not found, skipping ..."
        continue
    fi
    output_file="$1/cloud_enum.txt"
    echo "Scanning possible cloud containers found in $subdomains_file ..."
    python3 $CLOUD_ENUM_PATH -kf $subdomains_file -l $output_file
}

if [ -z $1 ]; then
    cli_help
fi

TARGETS_DIR=$1

if [ ! -d "$TARGETS_DIR" ]; then
    echo "Directory '$TARGETS_DIR' does not exist"
    cli_help
fi

echo "Targets directory: $TARGETS_DIR"
echo "Targets found:"
echo "$(ls $TARGETS_DIR)"

cd $TARGETS_DIR

# Loop over targets
for target in *; do 
    [[ -d $target ]] || continue
    cloud_enum "$TARGETS_DIR/$target"
done

echo ""
echo "Done."
