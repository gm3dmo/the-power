#!/usr/bin/env python3

"""
This is used to prepare the json files that are sent as a commit.
"""

__author__ = "David Morris (gm3dmo@gmail.com)"

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

    p = Path('tmp/').glob('wp_*.txt')
    for f in p:
       json_file = f"""tmp/{f.stem}.json"""
       filename_in_repo = f"""{f.stem}.{args.extension}"""
       with open(f, 'rb') as ct:
           t = {}
           chapter_content = ct.read()
           chapter_base64 = base64.encodebytes(chapter_content)
           t["message"] = f"""A new file for the project. Its name is: {filename_in_repo}"""
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
