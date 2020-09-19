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

## Enumerate subdomains of targets

```
Usage: ./enumerate.sh path/to/targets

Enumerates subdomains of a targets using amass
```

## Probe subdomains of targets

```
Usage: ./probe.sh path/to/targets

Probes subdomains of targets using httpx
```

## Scan for vulnerable storages

```
Usage: ./cloud_enum.sh path/to/targets

Scans for vulnerable cloud containers using cloud_enum
```

## Look for leaked credentials in VCS platforms

- _TODO_

## Take screenshots and analyze subdomains
- run `aquatone` against collected subdomains and write results to their respective `screenshots/` folders

## Monitor interesting files and web pages for changes
- _TODO_
- scan through `monitor/` folders for files to monitor file changes
