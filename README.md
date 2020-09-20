```
██████  ███████  ██████  ██████  ███    ██       ███████  ██████ ██████  ██ ██████  ████████ ███████ 
██   ██ ██      ██      ██    ██ ████   ██       ██      ██      ██   ██ ██ ██   ██    ██    ██      
██████  █████   ██      ██    ██ ██ ██  ██ █████ ███████ ██      ██████  ██ ██████     ██    ███████ 
██   ██ ██      ██      ██    ██ ██  ██ ██            ██ ██      ██   ██ ██ ██         ██         ██ 
██   ██ ███████  ██████  ██████  ██   ████       ███████  ██████ ██   ██ ██ ██         ██    ███████ 
```
                                                                                                     
# Personal recon framework for bug bounty hunting

## Dependencies

- [OWASP Amass](https://github.com/OWASP/Amass)
- [httpx](https://github.com/projectdiscovery/httpx)
- [Aquatone](https://github.com/michenriksen/aquatone)
- [S3Scanner](https://github.com/OWASP/Amass)
- [cloud_enum](https://github.com/initstring/cloud_enum)
- [GitHound](https://github.com/tillson/git-hound)

## Directory framework

This is the way I organize my recon loot. I just feed this directory to the tools here.

```
targets
├── target1
│   ├── screenshots/
│   ├── monitor/
│   ├── githound.txt
│   ├── cloud_enum.txt
│   ├── httpx.txt
│   ├── domains.txt
│   └── subdomains.txt
├── target2
│   ├── screenshots/
│   ├── monitor/
│   ├── githound.txt
│   ├── cloud_enum.txt
│   ├── httpx.txt
│   ├── domains.txt
│   └── subdomains.txt
│
.
.
```

## Setup

```
git clone https://github.com/tedmdelacruz/recon-scripts.git
cd recon-scripts

# Initialize a paths.sh from paths.sh.example
cp paths.sh.example paths.sh
vim paths.sh
```

## Overview
Manual reconnaisance tool that does the following to domains in a target:
- Enumerate subdomains using sublist3r
- Show GitHub dorking links @TODO
- Scan using Subdomainizer
- Probe subdomains using httpx
- Check cloud buckets using cloud_enum and S3scanner
- Check VCS leaks using githound @TODO
- Scan webpages using nuclei
- Take screenshots using aquatone

# Usage:
1. Clone this repository
2. Copy `paths.sh.example` into `paths.sh` and amend its contents accordingly

```bash
cd recon_scripts
# Note: target_dir requires a domains.txt file
$ ./recon.sh path/to/target_dir

# Or source the paths.sh and functions.sh to access individual functions like so:
$ source paths.sh; source functions.sh;
$ enumerate_subdomains path/to/target
$ probe_subdomains path/to/target
$ cloud_bucket_enum path/to/target
$ nuclei_scan path/to/target
$ take_screenshots path/to/target
```

## TODO
- Monitor interesting files and web pages for changes
