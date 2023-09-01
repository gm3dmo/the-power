#!/usr/bin/env python3

"""
This demonstrates connection re use creating organizations.

https://docs.github.com/en/enterprise-server/rest/enterprise-admin/orgs#create-an-organization
POST /admin/organizations
"""

__author__ = "David Morris (gm3dmo@gmail.com)"

import os
import json
import string
import base64
import argparse
import logging
import http
import thepower
from pathlib import Path
from datetime import datetime
import requests

def get_github_api_data(url, params=None):
    headers = {"Accept": "application/vnd.github.v3+json"}
    response_data = []

    while url:
        response = requests.get(url, headers=headers, params=params)
        response_json = response.json()
        response_data.extend(response_json)

        # Check for pagination in the Link header
        if 'link' in response.headers:
            links = response.headers['link']
            print(links)
            next_link = None

            for link in links.split(','):
                link_parts = link.split(';')
                if len(link_parts) == 2 and link_parts[1].strip() == 'rel="next"':
                    next_link = link_parts[0].strip()[1:-1]
                    break

            url = next_link
        else:
            url = None

    return response_data



def main(args):

    logger = logging.getLogger("root")
    FORMAT = "[%(filename)s:%(lineno)s - %(funcName)20s() ] %(message)s"
    logging.basicConfig(format=FORMAT)
    logger.setLevel(args.loglevel)
    logger.debug(f"""woot""")

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')

    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')


    # Example usage
    base_url = "https://api.github.com/repos/apache/camel/issues?per_page=2"
    params = {"state": "open"}
    issues_data = get_github_api_data(base_url, params=params)
    #print(issues_data)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "-d",
        "--debug",
        action="store_const",
        dest="loglevel",
        const=logging.INFO,
        default=logging.INFO,
        help="debug(-d, --debug, etc)",
    )

    args = parser.parse_args()

    main(args)
