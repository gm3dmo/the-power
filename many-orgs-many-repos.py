#!/usr/bin/env python3

"""
This script creates multiple organizations and repositories in one go.
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
from tqdm import tqdm

def create_orgs(args, conn, headers, logger):
    """Create multiple organizations"""
    org_names = []
    for i in tqdm(range(args.number_of_orgs), desc="Creating organizations"):
        org_name = f"""{args.org_prefix}-{i:07}"""
        logger.debug(f"creating {org_name}")
        params = {
                "login" : org_name,
                "profile_name" : f"{org_name} A Test Organization.",
                "admin" : f"{args.admin_user}"
               }
        params = json.dumps(params)
        logger.debug(params)
        url =  f"""{args.path_prefix}/admin/organizations"""
        conn.request('POST', url, params, headers=headers)
        r1 = conn.getresponse()
        logger.debug(r1.read())
        org_names.append(org_name)
    return org_names

def create_repos(args, conn, headers, org_name, logger):
    """Create multiple repositories in an organization"""
    for i in tqdm(range(args.number_of_repos), desc=f"Creating repos in {org_name}"):
        repo_name = f"""{args.repo_prefix}-{i:07}"""
        params = {
               "name": repo_name,
               "description": f"this is a repo: {i}",
               "private": True
               }
        params = json.dumps(params)
        url =  f"""{args.path_prefix}/orgs/{org_name}/repos"""
        conn.request('POST', url, params, headers=headers)
        r1 = conn.getresponse()
        logger.debug(r1.read())

def main(args):
    logger = logging.getLogger("root")
    FORMAT = "[%(filename)s:%(lineno)s - %(funcName)20s() ] %(message)s"
    logging.basicConfig(format=FORMAT)
    logger.setLevel(args.loglevel)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')

    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')
    args.admin_user = str(args.admin_user) or str(power_config.get('dummy_section','admin_user').strip('\"'))
    
    # Handle org prefix
    args.org_prefix = str(args.org_prefix) if args.org_prefix else \
        str(power_config.get('dummy_section','org_prefix').strip('\"'))
    
    # Handle repo prefix
    args.repo_prefix = str(args.repo_prefix) if args.repo_prefix else \
        str(power_config.get('dummy_section','repo_prefix').strip('\"'))
    
    # Handle number of orgs and repos
    args.number_of_orgs = int(args.number_of_orgs) if args.number_of_orgs else \
        int(power_config.get('dummy_section','number_of_orgs').strip('\"'))
    args.number_of_repos = int(args.number_of_repos) if args.number_of_repos else \
        int(power_config.get('dummy_section','number_of_repos').strip('\"'))

    conn = http.client.HTTPSConnection(args.hostname)
    token = f"""Bearer {args.GITHUB_TOKEN}"""
    headers = {
               "Authorization" : token,
               "Accept" :  "application/vnd.github.v3+json"
              }

    # Create orgs and repos
    org_names = create_orgs(args, conn, headers, logger)
    for org_name in org_names:
        if args.number_of_repos > 0:
            create_repos(args, conn, headers, org_name, logger)

    conn.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "--orgs",
        action="store",
        dest="number_of_orgs",
        help="The number of orgs to create.",
    )
    parser.add_argument(
        "--repos",
        action="store",
        dest="number_of_repos",
        help="The number of repos to create in each org.",
    )
    parser.add_argument(
        "--org-prefix",
        action="store",
        dest="org_prefix",
        default=None,
        help="the prefix for the org name.",
    )
    parser.add_argument(
        "--repo-prefix",
        action="store",
        dest="repo_prefix",
        default=None,
        help="the prefix for the repo name.",
    )
    parser.add_argument(
        "--admin-user",
        action="store",
        dest="admin_user",
        default='ghe-admin',
        help="the admin user."
    )
    parser.add_argument(
        "-d",
        "--debug",
        action="store_const",
        dest="loglevel",
        const=logging.DEBUG,
        default=logging.INFO,
        help="debug(-d, --debug, etc)",
    )

    args = parser.parse_args()
    main(args) 