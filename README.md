```
   ________  _________  ____     _______________(_)___  / /______
  / ___/ _ \/ ___/ __ \/ __ \   / ___/ ___/ ___/ / __ \/ __/ ___/
 / /  /  __/ /__/ /_/ / / / /  (__  ) /__/ /  / / /_/ / /_(__  ) 
/_/   \___/\___/\____/_/ /_/  /____/\___/_/  /_/ .___/\__/____/  
                                              /_/                
```

![v0.1.0](https://img.shields.io/badge/version-0.1.0-brightgreen?style=for-the-badge&logo=python)
                                                                                                     
# Personal recon framework for bug bounty hunting

- Enumerate subdomains using [Sublist3r](https://github.com/aboul3la/Sublist3r) and [Subdominizer](https://github.com/nsonaniya2010/SubDomainizer)
- Probe subdomains using [httpx](https://github.com/projectdiscovery/httpx)
- Check cloud buckets using [cloud_enum](https://github.com/initstring/cloud_enum) and [S3Scanner](https://github.com/OWASP/Amass)
- Scan webpages using [nuclei](https://github.com/projectdiscovery/nuclei)
- Take screenshots using [Aquatone](https://github.com/michenriksen/aquatone)
- Asset discovery using [hakrawler](https://github.com/hakluke/hakrawler) 
- Scan for XSS from asset discovery using [XSStrike](https://github.com/s0md3v/XSStrike)
- Notify for new URLs or JS files discovered via Slack

## Directory framework

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
bash <(curl -s https://raw.githubusercontent.com/tedmdelacruz/recon-scripts/master/configure)

# Initialize a vars.sh from vars.sh.example
cd .recon-scripts/includes
cp vars.sh.example vars.sh
vim vars.sh
```

# Usage:
1. Run predefined scans
```sh
cd recon_scripts
# Note: target_dir requires a domains.txt file
$ scans/sweep.sh path/to/targets_dir
$ scans/snipe.sh path/to/targets_dir/target
```

2. Or execute individual functions like so:
```sh
$ source vars.sh; source functions.sh;
$ enumerate_subdomains path/to/target
$ probe_subdomains path/to/target
$ cloud_bucket_enum path/to/target
$ nuclei_scan path/to/target
$ take_screenshots path/to/target
```

## TODO
- Monitor interesting files and web pages for changes
- Show GitHub dorking links
- Setup port scanning using `dnmasscan`, `masscan`, and `nmap`
- Support multithreading
