```
   ________  _________  ____     _______________(_)___  / /______
  / ___/ _ \/ ___/ __ \/ __ \   / ___/ ___/ ___/ / __ \/ __/ ___/
 / /  /  __/ /__/ /_/ / / / /  (__  ) /__/ /  / / /_/ / /_(__  ) 
/_/   \___/\___/\____/_/ /_/  /____/\___/_/  /_/ .___/\__/____/  
                                              /_/                
```
![v0.0.1-alpha](https://img.shields.io/badge/version-0.0.1--alpha-green)
                                                                                                     
# Personal recon framework for bug bounty hunting
Collection of reconnaissance scripts does the following to domains in a target:
- Enumerate subdomains using sublist3r
- Scan using Subdomainizer
- Probe subdomains using httpx
- Check cloud buckets using cloud_enum and S3scanner
- Scan webpages using nuclei
- Take screenshots using aquatone
- Asset discovery using hakrawler
- Notify for new URLs or JS files discovered via Slack

## Dependencies

- [Sublist3r](https://github.com/aboul3la/Sublist3r)
- [Subdominizer](https://github.com/nsonaniya2010/SubDomainizer)
- [httpx](https://github.com/projectdiscovery/httpx)
- [Aquatone](https://github.com/michenriksen/aquatone)
- [S3Scanner](https://github.com/OWASP/Amass)
- [cloud_enum](https://github.com/initstring/cloud_enum)
- [hakrawler](https://github.com/hakluke/hakrawler)
- [GitHound](https://github.com/tillson/git-hound)

## Directory framework

This is the way I organize my recon loot. I just feed this directory to the tools here.

```
targets
├── target1
│   ├── screenshots/
│   ├── urls.txt
│   ├── js.txt
│   ├── githound.txt
│   ├── cloud_enum.txt
│   ├── httpx.txt
│   ├── domains.txt
│   └── subdomains.txt
├── target2
│   ├── screenshots/
│   ├── urls.txt
│   ├── js.txt
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

# Initialize a variables.sh from variables.sh.example
cp variables.sh.example variables.sh
vim variables.sh
```

# Usage:
1. Clone this repository
2. Copy `variables.sh.example` into `variables.sh` and amend its values accordingly

```bash
cd recon_scripts
# Note: target_dir requires a domains.txt file
$ ./recon.sh path/to/target_dir
```

3. Or source `variables.sh` and `functions.sh` to access individual functions like so:
```
$ source variables.sh; source functions.sh;
$ enumerate_subdomains path/to/target
$ probe_subdomains path/to/target
$ cloud_bucket_enum path/to/target
$ nuclei_scan path/to/target
$ take_screenshots path/to/target
```

## TODO
- Monitor interesting files and web pages for changes
- Check for repository leaks using githound
- Show GitHub dorking links
