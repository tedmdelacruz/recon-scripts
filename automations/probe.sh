#!/usr/bin/env bash

set -e

cli_help(){
    echo "Usage: ./probe.sh path/to/targets"
exit 1
}

probe(){
    subdomains_file="$1/subdomains.txt"
    if [ ! -f $subdomains_file ]; then
        echo "$subdomains_file not found, skipping ..."
        continue
    fi
    output_file="$1/httpx.txt"
    echo "Probing hosts found in $subdomains_file ..."
    httpx -silent -l $subdomains_file > $output_file
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
    probe "$TARGETS_DIR/$target"
done

echo ""
echo "Done."
