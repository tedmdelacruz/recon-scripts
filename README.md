```
   ________  _________  ____     _______________(_)___  / /______
  / ___/ _ \/ ___/ __ \/ __ \   / ___/ ___/ ___/ / __ \/ __/ ___/
 / /  /  __/ /__/ /_/ / / / /  (__  ) /__/ /  / / /_/ / /_(__  ) 
/_/   \___/\___/\____/_/ /_/  /____/\___/_/  /_/ .___/\__/____/  
                                              /_/                
```

![v0.2.1](https://img.shields.io/badge/version-0.2.1-brightgreen?style=flat)
                                                                                                     
# A simple recon framework for bug bounty hunting

- Enumerate subdomains using [Sublist3r](https://github.com/aboul3la/Sublist3r) and [Subdominizer](https://github.com/nsonaniya2010/SubDomainizer)
- Probe subdomains using [httpx](https://github.com/projectdiscovery/httpx)
- Check cloud buckets using [cloud_enum](https://github.com/initstring/cloud_enum) and [S3Scanner](https://github.com/OWASP/Amass)
- Scan webpages using [nuclei](https://github.com/projectdiscovery/nuclei)
- Take screenshots using [Aquatone](https://github.com/michenriksen/aquatone)
- Asset discovery using [hakrawler](https://github.com/hakluke/hakrawler) 
- Scan for XSS from asset discovery using [XSStrike](https://github.com/s0md3v/XSStrike)
- Notify for new URLs or JS files discovered via Slack

**The idea is to turn this:**
```
targets
├── tesla
│   └── domains.txt
└── shopify
    └── domains.txt
```

**into this:**
```
targets
├── tesla
│   ├── screenshots/
│   ├── urls.txt
│   ├── js.txt
│   ├── githound.txt
│   ├── cloud_enum.txt
│   ├── httpx.txt
│   ├── domains.txt
│   └── subdomains.txt
├── shopify
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

\* Inspired by [lazyrecon](https://github.com/nahamsec/lazyrecon) by [nahamsec](https://github.com/nahamsec)

\* Warning: this code was originally created for personal use

\* I'm not very good at bash, please point out any weird quirks that could use some improvements ♥

## Setup

**Bash one-line setup. Installs recon-scripts to $HOME/.recon-scripts**
```sh
bash <(curl -s https://raw.githubusercontent.com/tedmdelacruz/recon-scripts/master/configure)
```

**Initialize a vars.sh from vars.sh.example**
```
cd .recon-scripts
cp vars.sh.example vars.sh
vim vars.sh
```

## Usage:
**Run predefined scans**
```sh
cd .recon_scripts
$ scans/sweep.sh # Scan all targets in recon folder
$ scans/snipe.sh tesla shopify # Probe and quick scan
$ scans/bombard.sh shopify # Comprehensive scan
```

**Or execute individual functions like so:**
```sh
$ enumerate_subdomains domain.com path/to/targets_dir/target
$ probe_subdomains path/to/target
$ cloud_bucket_enum path/to/target
$ nuclei_scan path/to/target
$ take_screenshots path/to/target
```

## TODO
- Configure API key inclusion to subdomain enumerations
- Monitor interesting files and web pages for changes
- Show GitHub dorking links
- Setup port scanning using `dnmasscan`, `masscan`, and `nmap`
- Support multithreading
- Add script for scaffolding directories
- Add reporting
- Integrate custom `nuclei` workflows
