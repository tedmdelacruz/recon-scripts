# Personal automated recon tools for bug bounty hunting

## Enumerate subdomains of targets
- scan through `~/recon` folder for targets using `amass enum -df <subdomains>`
- write results to respective `subdomains/` folders of targets using `amass db -names -df <subdomains> > YYYYMMDD.txt`
- notify for new subdomains using Pushover

## Scan for vulnerable storages

## Look for leaked credentials in VCS platforms

## Take screenshots and analyze subdomains
- run `aquatone` against collected subdomains and write results to their respective `intel/` folders
- configure aquatone to use `masscan` for scanning ports

## Monitor interesting files and web pages for changes
- scan through `monitor/` folders for files to monitor file changes
