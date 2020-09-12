import os
import subprocess


class HttpX(object):
    """Simple Python wrapper for HttpX"""

    output_file = "httpx.txt"

    def __init__(self, hosts, output_dir):
        if not os.path.isfile(hosts):
            raise IOError("%s file not found" % hosts)

        self.hosts = hosts
        self.output_dir = output_dir

    def probe(self):
        """Probes hosts using HttpX then writes the results into httpx.txt"""
        with open(os.path.join(self.output_dir, self.output_file), "w+") as f:
            subprocess.run(["httpx", "-silent", "-l", self.hosts], check=True, stdout=f)
