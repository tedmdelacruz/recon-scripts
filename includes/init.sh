#!/bin/bash

source "$HOME/.recon-scripts/vars.sh"

echo -e "${BPurple} 
   ________  _________  ____     _______________(_)___  / /______
  / ___/ _ \/ ___/ __ \/ __ \   / ___/ ___/ ___/ / __ \/ __/ ___/
 / /  /  __/ /__/ /_/ / / / /  (__  ) /__/ /  / / /_/ / /_(__  ) 
/_/   \___/\___/\____/_/ /_/  /____/\___/_/  /_/ .___/\__/____/  
                                              /_/
"
echo -e "${BPurple}Version:${Reset} $(cat "$HOME/.recon-scripts/VERSION") "
echo -e "${BPurple}Author:${Reset}  tedm.infosec"
# echo -e "${BPurple}Contributors:${Reset} Your name here!"
echo ""

sleep 1

if [ ! -d "$TARGETS_DIR" ]; then
    echo -e "${Red}Directory '$TARGETS_DIR' does not exist${Reset}"
    exit 0
fi

if [ "$#" -gt 0 ]; then
    for target in $@; do
        if [ ! -d "$TARGETS_DIR/$target" ]; then
            echo -e "${Red}$target is not a valid target in $TARGETS_DIR${Reset}"
            exit 0
        fi
    done
    SELECTED_TARGETS=$@
fi

echo -e "$Info Directory containing targets: $TARGETS_DIR"
if [ ! -z "$SELECTED_TARGETS" ]; then
    echo -e "$Info Selected targets: $SELECTED_TARGETS"
fi

delete_empty_files() {
    find $1 -size 0 -delete
}
