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
from pathlib import Path
from datetime import datetime


def main(args):

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')
    args.default_committer = power_config.get('dummy_section','default_committer',).strip('"')
    args.org = power_config.get('dummy_section','org',).strip('"')
    args.team_slug = power_config.get('dummy_section','team_slug',).strip('"')

    p = Path('test-data/CODEOWNERS.template')
    json_file = f"""tmp/create-commit-codeowners.json"""
    filename_in_repo = f"""CODEOWNERS"""
    with open(p, 'rb') as ct:
       t = {}
       chapter_content = ct.read()
       chapter_string = string.Template(chapter_content.decode("utf-8"))
       values = { "org": args.org, "team_slug": args.team_slug, "default_committer": args.default_committer }
       n = chapter_string.substitute(values)
       chapter_content = bytes(n, 'utf-8')
       chapter_base64 = base64.encodebytes(chapter_content)
       t["message"] = f"""A CODEOWNERS file."""
       t["committer"] = {}
       t["committer"]["name"] = args.default_committer
       t["committer"]["email"] = f"noreply+{args.default_committer}@example.com"
       t["content"] = chapter_base64.decode('UTF-8')

       with open(json_file, 'w') as out_file:
          out_file.write(json.dumps(t))

if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")
    args = parser.parse_args()

    main(args)
