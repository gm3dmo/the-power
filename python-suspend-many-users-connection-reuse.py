#!/usr/bin/env python3

import os
import sys
import json
import time
import string
import base64
import argparse
import logging
import http
import thepower
from pathlib import Path
from datetime import datetime


def postit(conn, url, params, headers):
    conn.request('POST', url, params, headers=headers)
    r1 = conn.getresponse()
    r1.read()


def putit(conn, url, params, headers):
    conn.request('PUT', url, params, headers=headers)
    r1 = conn.getresponse()
    r1.read()


def main(args):

    loglevel = args.loglevel.upper()
    logging.basicConfig(level=loglevel)
    logger = logging.getLogger(__name__)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')

    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')

    args.number_of_users_to_create_on_ghes = int(power_config.get('dummy_section','number_of_users_to_create_on_ghes'))
    args.user_prefix = (power_config.get('dummy_section','user_prefix')).strip('"')

    logger.info(f"""creating: {args.number_of_users_to_create_on_ghes} users""")
    logger.info(f"""creating: {args.user_prefix} prefix for username""")


    token = f"""Bearer {args.GITHUB_TOKEN}"""

    conn = http.client.HTTPSConnection(args.hostname)

    # time how lng it takes to create all the things
    ts = time.time()
    start = datetime.now()
    for i in range(args.number_of_users_to_create_on_ghes):
        headers = {
               "Authorization" : token,
               "Accept" :  "application/vnd.github.v3+json",
               "User-Agent" : f"""the-power-{i}"""
              }
        
        username  = f"""{args.user_prefix}-{i:07}"""
        params = {
                "reason": f"{username} is a very naughty boy."
               }
        params = json.dumps(params)
        url =  f"""{args.url}/users/username"""
        logger.debug(f"""suspending: {username}""")
        try:
           logger.debug(f"""creating username {username}""")
           logger.debug(f"""sending params {params}""")
           logger.debug(f"""sending request {i}""")
           putit(conn, url, params, headers)
        except Exception as e:
           print(f"""Error: {e}""") 

    end = datetime.now()
    elapsed = end - start
    print(f"""elapsed time: {elapsed} to create {args.number_of_users_to_create_on_ghes} users""", file=sys.stderr)

    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "--users",
        action="store",
        dest="number_of_users_to_create_on_ghes",
        help="The number of users to create on GHES.",
    )
    parser.add_argument(
        "-l",
        "--loglevel",
        action="store",
        dest="loglevel",
        default="info",
        help="Set the log level",
    )

    args = parser.parse_args()


    main(args)


