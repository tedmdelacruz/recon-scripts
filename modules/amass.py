import os
import subprocess

class Amass(object):
    """Python wrapper for amass cli"""

    domains_file = "domains.txt"
    subdomains_file = "subdomains.txt"

    def __init__(self, domains, **kwargs):
        self.domains = ",".join(domains)
        self.target_dir = kwargs["target_dir"] if "target_dir" in kwargs else None
        self.config = kwargs["config"] if "config" in kwargs else None
        self.dir = kwargs["dir"] if "dir" in kwargs else None

        with open(os.path.join(self.target_dir, self.domains_file), "w+") as f:
            f.writelines(domains)


    def enum_subdomains(self):
        cmd = ["amass", "enum", "-d", self.domains, "-dir", self.dir]
        if self.config:
            cmd = cmd + ["-config", self.config]
        subprocess.run(cmd, check=True)

    def write_subdomains(self):
        cmd = ["amass", "db", "-names", "-d", self.domains, "-dir", self.dir]
        with open(os.path.join(self.target_dir, self.subdomains_file), "w+") as f:
            subprocess.run(cmd, check=True, stdout=f)

    def track_subdomains(self):
        cmd = ["amass", "track", "-last", "2", "-d", self.domains, "-dir", self.dir]
        subprocess.run(cmd, check=True, capture_output=True)

