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
recon
├── target1
│   ├── amass/
│   ├── intel/
│   ├── monitor/
│   ├── githound.txt
│   ├── cloud_enum.txt
│   ├── httpx.txt
│   ├── domains.txt
│   └── subdomains.txt
├── target2
│   ├── amass/
│   ├── intel/
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
pip3 install -r requirements.txt
```

## Usage

1. Rename config.yaml.example to config.yaml
2. Adjust values in config.yaml accordingly

## Enumerate subdomains of targets

```
Usage: enumerate.py [OPTIONS]

  Enumerates subdomains of a target using amass

Options:
  --config TEXT  Configuration file to use
  --target TEXT  Specific target in config to enumerate
  --help         Show this message and exit
```

## Probe subdomains of targets

```
Usage: probe.py [OPTIONS]

  Probes domains using HttpX

Options:
  --config TEXT  Configuration file to use
  --target TEXT  Specific target in config to enumerate
  --help         Show this message and exit
```

## Scan for vulnerable storages

- _TODO_

## Look for leaked credentials in VCS platforms

- _TODO_

## [screenshot] Take screenshots and analyze subdomains
- run `aquatone` against collected subdomains and write results to their respective `intel/` folders
- configure aquatone to use `masscan` for scanning ports _TODO_

## Monitor interesting files and web pages for changes
- _TODO_
- scan through `monitor/` folders for files to monitor file changes
