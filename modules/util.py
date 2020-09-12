import click

# Taken from https://github.com/s0md3v/Arjun/blob/master/core/colors.py
white = '\033[97m'
green = '\033[92m'
red = '\033[91m'
yellow = '\033[93m'
end = '\033[0m'
back = '\033[7;91m'
info = '\033[93m[!]\033[0m'
que = '\033[94m[?]\033[0m'
bad = '\033[91m[-]\033[0m'
good = '\033[92m[+]\033[0m'
run = '\033[97m[~]\033[0m'

def banner():
    banner = """
███████ ███    ██ ██    ██ ███    ███ 
██      ████   ██ ██    ██ ████  ████ 
█████   ██ ██  ██ ██    ██ ██ ████ ██ 
██      ██  ██ ██ ██    ██ ██  ██  ██ 
███████ ██   ████  ██████  ██      ██ 

    
Custom subdomain enumeration script using amass
"""
    click.secho(banner, fg="blue")
