import os
import subprocess


class Amass(object):
    """Python wrapper for amass cli"""

    domains_file = "domains.txt"
    subdomains_file = "subdomains.txt"

    def __init__(self, domains, **kwargs):
        self.domains = domains
        self.domains_list = ",".join(domains)
        self.target_dir = kwargs.get("target_dir")
        self.config = kwargs.get("config")
        self.amass_dir = kwargs.get("amass_dir")

        with open(os.path.join(self.target_dir, self.domains_file), "w+") as f:
            f.writelines(self.domains)

    def enum_subdomains(self):
        for domain in self.domains:
            cmd = ["amass", "enum", "-d", domain, "-dir", self.amass_dir]
            if self.config:
                cmd = cmd + ["-config", self.config]
            subprocess.run(cmd, check=True)

    def write_subdomains(self):
        cmd = ["amass", "db", "-names", "-d", self.domains_list, "-dir", self.amass_dir]
        with open(os.path.join(self.target_dir, self.subdomains_file), "w+") as f:
            subprocess.run(cmd, check=True, stdout=f)

    def track_subdomains(self):
        cmd = ["amass", "track", "-last", "2", "-d", self.domains_list, "-dir", self.amass_dir]
        subprocess.run(cmd, check=True, capture_output=True)
