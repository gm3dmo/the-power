#!/usr/bin/env python3
"""
This creates a json file for upload to the GitHub REST API
"""


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

    p = Path('test-data/log4j-pom.xml_')
    json_file = f"""tmp/log4j-pom-xml.json"""
    filename_in_repo = f"""pom.xml"""
    with open(p, 'rb') as ct:
       t = {}
       chapter_content = ct.read()
       chapter_base64 = base64.encodebytes(chapter_content)
       t["message"] = f"""A pom.xml file containing the log4j vulnerability."""
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
