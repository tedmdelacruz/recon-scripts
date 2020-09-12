import os
import yaml
import click

# Taken from https://github.com/s0md3v/Arjun/blob/master/core/colors.py
white = "\033[97m"
green = "\033[92m"
red = "\033[91m"
yellow = "\033[93m"
end = "\033[0m"
back = "\033[7;91m"
info = "\033[93m[!]\033[0m"
que = "\033[94m[?]\033[0m"
bad = "\033[91m[-]\033[0m"
good = "\033[92m[+]\033[0m"
run = "\033[97m[~]\033[0m"


def initialize(config, target):
    """Initializes target directories conforming with the framework

    recon
        ├── target1
        │   ├── amass/
        │   ├── intel/
        │   ├── monitor/
        │   ├── githound.txt
        │   ├── cloud_enum.txt
        │   ├── httpx.txt
        │   ├── domains.txt
        │   └── subdomains.txt
        ├── target2
        │   ├── amass/
        │   ├── intel/
        │   ├── monitor/
        │   ├── githound.txt
        │   ├── cloud_enum.txt
        │   ├── httpx.txt
        │   ├── domains.txt
        │   └── subdomains.txt
    """

    settings = yaml.safe_load(open(config, "r"))
    if target == "all":
        targets = settings["targets"]
    elif target in settings["targets"]:
        targets = settings["targets"][target]
    else:
        click.echo("%s Target %s not a valid target in %s" % (bad, target, config))
        quit()

    targets_dir = os.path.abspath(os.path.expanduser(settings["targets_dir"]))
    click.echo("%s Targets directory: %s" % (info, targets_dir))
    if not os.path.isdir(targets_dir):
        os.mkdir(targets_dir)

    for t in targets:
        target_dir = os.path.join(targets_dir, t)
        if not os.path.isdir(target_dir):
            os.mkdir(target_dir)

    return targets, targets_dir
