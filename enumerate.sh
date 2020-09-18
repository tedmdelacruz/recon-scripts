#!/usr/bin/env bash

set -e

cli_help(){
    echo "Usage: ./enumerate.sh path/to/targets"
exit 1
}

enumerate(){
    echo "Enumerating subdomains of $1..."
    tmp_outfile="$(date +'%d%m%Y').txt"
    amass enum -v -config="$HOME/amass.ini" -df="$2/domains.txt" -o="$2/$tmp_outfile.txt"
    cat $tmp_outfile >> subdomains.txt
    sort -u -o subdomains.txt subdomains.txt
    rm $tmp_outfile
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
    [ -d $target ] || continue

    domains_file="$TARGETS_DIR/$target/domains.txt"
    if [ ! -f $domains_file ]; then
        echo "$domains_file not found, skipping..."
        continue
    fi

    enumerate $target "$TARGETS_DIR/$target"
done

echo ""
echo "Done."
