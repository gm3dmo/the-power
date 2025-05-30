#!/usr/bin/env python3
"""
Module Docstring
"""

__author__ = "David Morris (gm3dmo@gmail.com)"
__version__ = "0.1.0"
__license__ = "MIT"

import os
import json
import string
import base64
import argparse
import logging
import thepower
import time
from pathlib import Path
from datetime import datetime


def main(args):

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')
    args.default_committer = power_config.get('dummy_section','default_committer',).strip('"')
    args.branch_name = power_config.get('dummy_section','branch_name',).strip('"')
    args.default_issue_id = power_config.get('dummy_section','default_issue_id',).strip('"')

    p = Path('test-data/README-update.md_')
    json_file = f"""tmp/create-commit-update-readme.json"""
    filename_in_repo = f"""docs/README.md"""
    with open(p, 'rb') as ct:
       t = {}
       ts = time.time()
       chapter_content = ct.read()
       chapter_base64 = base64.encodebytes(chapter_content)
       t["message"] = f"""Updating the docs/README.md file {ts} close #{args.default_issue_id}"""
       t["committer"] = {}
       t["sha"] = args.blob_sha
       t["branch"] = args.branch_name
       t["committer"]["name"] = args.default_committer
       t["committer"]["email"] = f"noreply+{args.default_committer}@example.com"
       t["content"] = chapter_base64.decode('UTF-8')
       with open(json_file, 'w') as out_file:
          out_file.write(json.dumps(t))

if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("--blob-sha", action="store", dest="blob_sha", default="", help="The blob. Nothing can stop it.")
    args = parser.parse_args()

    main(args)
