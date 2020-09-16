#!/usr/bin/env python3
import os
import click
from modules.util import info, good, bad, run, initialize
from modules.httpx import HttpX


@click.command()
@click.option("--config", default="config.yaml", help="Configuration file to use")
@click.option("--target", default="all", help="Specific target in config to enumerate")
def main(config, target):
    """Probes domains using HttpX"""
    targets, targets_dir = initialize(config, target)

    # Loop over targets and create missing folders in targets directory accordingly
    click.echo("%s Targets found: %s" % (info, ",".join(targets)))
    for t in targets:
        target_dir = os.path.join(targets_dir, t)
        click.echo("%s Probing subdomains of %s..." % (run, t))
        httpx = HttpX(os.path.join(target_dir, "subdomains.txt"), target_dir)
        httpx.probe()
        click.echo("%s Successfully probed subdomains of %s" % (good, t))


if __name__ == "__main__":
    main()
