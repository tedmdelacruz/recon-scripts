#!/usr/bin/env bash

set -e

cli_help(){
    echo "Usage: ./enumerate.sh path/to/targets"
exit 1
}

enumerate(){
    domains_file="$1/domains.txt"
    if [ ! -f $domains_file ]; then
        echo "$domains_file not found, skipping ..."
        continue
    fi

    while IFS= read -r domain; do
        [[ ! -z $domain ]] || continue
        echo "Enumerating subdomains of $domain ..."
        tmp_file="$1/$RANDOM.txt"
        subdomains_file="$1/subdomains.txt"
        amass enum -v -config="$HOME/amass.ini" -dir="$HOME/.amass" -d=$domain -o=$tmp_file
        cat $tmp_file >> $subdomains_file
        sort -u -o $subdomains_file $subdomains_file 
        rm $tmp_file
    done < "$domains_file"
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
    enumerate "$TARGETS_DIR/$target"
done

echo ""
echo "Done."
