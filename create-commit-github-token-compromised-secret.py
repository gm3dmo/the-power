#!/usr/bin/env python3
"""
Generate JSON payload to commit github.token.compromised.secret.txt to the repo.
"""

__author__ = "David Morris (gm3dmo@gmail.com)"
__version__ = "0.1.0"
__license__ = "MIT"

import json
import base64
import argparse
import thepower
from pathlib import Path


def main(args):

    power_config = thepower.read_dotcom_config(args.power_config)
    args.default_committer = power_config.get('dummy_section','default_committer',).strip('"')

    p = Path('github.token.compromised.secret.txt')
    json_file = "tmp/create-commit-github-token-compromised-secret.json"
    with open(p, 'rb') as ct:
       t = {}
       chapter_content = ct.read()
       chapter_base64 = base64.encodebytes(chapter_content)
       t["message"] = "Adding github.token.compromised.secret.txt"
       t["committer"] = {}
       t["committer"]["name"] = args.default_committer
       t["committer"]["email"] = f"noreply+{args.default_committer}@example.com"
       t["content"] = chapter_base64.decode('UTF-8')

       with open(json_file, 'w') as out_file:
          out_file.write(json.dumps(t))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    args = parser.parse_args()

    main(args)
