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

    p = Path('test-data/workflow-github-app.yml_')


    json_file = f"""tmp/workflow-github-app.json"""
    filename_in_repo = f"""workflow-github-app.yml"""

    with open(p, 'rb') as ct:
       t = {}
       t["org"] = "test1"
       #t["org"] = args.org

       chapter_content = ct.read()
       chapter_out = string.Template(chapter_content.decode("utf-8"))
       print(chapter_out)

       chapter_base64 = base64.encodebytes(chapter_content)

       with open(json_file, 'w') as out_file:
          out_file.write(json.dumps(t))

if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")
    args = parser.parse_args()

    main(args)
