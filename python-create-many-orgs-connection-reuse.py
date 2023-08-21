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
    args.admin_user = str(args.admin_user) or str(power_config.get('dummy_section','admin_user').strip('\"'))
    args.org_prefix = str(args.org_prefix) or str(power_config.get('dummy_section','org_prefix').strip('\"'))
    args.number_of_orgs = int(args.number_of_orgs) or int(power_config.get('dummy_section','number_of_orgs').strip('\"'))

    conn =http.client.HTTPSConnection(args.hostname)

    token = f"""Bearer {args.GITHUB_TOKEN}"""
    headers = {
               "Authorization" : token,
               "Accept" :  "application/vnd.github.v3+json"
              }

    for i in range(args.number_of_orgs):
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

    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "--orgs",
        action="store",
        dest="number_of_orgs",
        default=False,
        help="The number of orgs to create.",
    )
    parser.add_argument(
        "--prefix",
        action="store",
        dest="org_prefix",
        default=False,
        help="the prefix for the org name.",
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
        const=logging.INFO,
        default=logging.INFO,
        help="debug(-d, --debug, etc)",
    )

    args = parser.parse_args()

    main(args)
