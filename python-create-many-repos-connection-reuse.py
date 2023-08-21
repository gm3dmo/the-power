#!/usr/bin/env python3

"""
This demonstrates connection re use 
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

def main(args):

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')

    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')
    args.org = args.org or power_config.get('dummy_section','org').strip('\"')

    args.repo_prefix = args.repo_prefix or power_config.get('dummy_section','repo_prefix').strip('\"')
    args.number_of_repos = int(args.number_of_repos) or int(power_config.get('dummy_section','number_of_repos'))

    conn =http.client.HTTPSConnection(args.hostname)

    token = f"""Bearer {args.GITHUB_TOKEN}"""
    headers = {
               "Authorization" : token,
               "Accept" :  "application/vnd.github.v3+json"
              }

    for i in range(args.number_of_repos):
        repo_name = f"""{args.repo_prefix}-{i:07}"""
        params = {
               "name": repo_name,
               "description": f"this is a repo: {i}",
               "private": True
               }
        params = json.dumps(params)
        url =  f"""{args.path_prefix}/orgs/{args.org}/repos"""
        conn.request('POST', url, params, headers=headers)
        r1 = conn.getresponse()
        r1.read()

    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "--repos",
        action="store",
        dest="number_of_repos",
        default=False,
        help="The number of repos to create.",
    )
    parser.add_argument(
        "--prefix",
        action="store",
        dest="repo_prefix",
        default=False,
        help="the prefix for the repo name.",
    )
    parser.add_argument(
        "--org",
        action="store",
        dest="org",
        default=False,
        help="the organization name. 
    )

    args = parser.parse_args()

    main(args)
