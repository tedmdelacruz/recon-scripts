#!/usr/bin/env python3
import os
import click
import yaml
from modules.util import info, good, bad, run, initialize
from modules.amass import Amass

banner = """
███████ ███    ██ ██    ██ ███    ███ 
██      ████   ██ ██    ██ ████  ████ 
█████   ██ ██  ██ ██    ██ ██ ████ ██ 
██      ██  ██ ██ ██    ██ ██  ██  ██ 
███████ ██   ████  ██████  ██      ██ 

    
Custom subdomain enumeration script using amass
"""


@click.command()
@click.option("--config", default="config.yaml", help="Configuration file to use")
@click.option("--target", default="all", help="Specific target in config to enumerate")
def main(config, target):
    """Enumerates subdomains of a target using amass"""
    click.secho(banner, fg="blue")
    settings = yaml.safe_load(open(config, "r"))
    targets, targets_dir = initialize(config, target)

    amass_config = os.path.abspath(os.path.expanduser(settings["amass_config_path"]))
    click.echo("%s Amass configuration file: %s" % (info, amass_config))
    if not os.path.isfile(amass_config):
        amass_config = None

    # Loop over targets and create missing folders in targets directory accordingly
    click.echo("%s Targets found: %s" % (info, ",".join(targets)))
    for t in targets:
        target_dir = os.path.join(targets_dir, t)
        amass_dir = os.path.join(target_dir, "amass")
        if not os.path.isdir(amass_dir):
            os.mkdir(amass_dir)
        amass = Amass(
            settings["targets"][t]["domains"],
            amass_dir=amass_dir,
            target_dir=target_dir,
            config=amass_config,
        )

        click.echo("%s Enumerating subdomains of %s using amass enum..." % (run, t))
        amass.enum_subdomains()
        click.echo("%s Done enumerating subdomains of %s" % (good, t))

        click.echo("%s Writing subdomains of %s using amass db..." % (run, t))
        amass.write_subdomains()
        click.echo(
            "%s Done writing subdomains of %s into %s/%s"
            % (good, t, target_dir, amass.subdomains_file)
        )

if __name__ == "__main__":
    main()
