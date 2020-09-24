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

sleep 2

if [ ! -d "$TARGETS_DIR" ]; then
    echo -e "${Red}Directory '$TARGETS_DIR' does not exist${Reset}"
    exit 0
fi

echo -e "$Info Targets directory: $TARGETS_DIR"
echo -e "$Info Targets found:"
echo -e "$(ls $TARGETS_DIR)"

cd $TARGETS_DIR
