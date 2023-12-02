#!/usr/bin/env python3

import os
import sys
import json
import string
import base64
import argparse
import logging
import http
import thepower
from strom import create_issue
from pathlib import Path
from datetime import datetime



def main(args):
    loglevel = args.loglevel.upper()
    logging.basicConfig(level=loglevel)
    logger = logging.getLogger(__name__)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get("dummy_section", "file_extension").strip('"')

    args.url = power_config.get("dummy_section", "GITHUB_API_BASE_URL")
    args.hostname = power_config.get("dummy_section", "hostname")
    args.GITHUB_TOKEN = power_config.get("dummy_section", "GITHUB_TOKEN")
    args.org = power_config.get("dummy_section", "org").strip('"')
    args.repo = power_config.get("dummy_section", "repo").strip('"')

    args.number_of_issues = int(args.number_of_issues) or int(
        power_config.get("dummy_section", "number_of_issues")
    )

    quantity = args.number_of_issues
    subject = "issues"
    logger.info(f"""creating: {quantity} issues""")

    token = f"""Bearer {args.GITHUB_TOKEN}"""
    headers = {
        "Authorization": token,
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "the-power",
    }

    conn = http.client.HTTPSConnection(args.hostname)

    # time how lng it takes to create the issues
    start = datetime.now()
    for i in range(args.number_of_issues):
        issue = f"""test-issue-{i:07}"""
        params = {
            "title": f"issue test: {issue}",
            "body": f"issue test: {issue}",
        }
        params = json.dumps(params)
        url = f"""{args.url}/repos/{args.org}/{args.repo}/issues"""
        try:
            logger.debug(f"""sending request {i}""")
            create_issue(conn, url, params, headers)
        except Exception as e:
            print(f"""Error: {e}""")

    end = datetime.now()
    elapsed = end - start
    print(
        f"""elapsed time: {elapsed} to create {quantity} {subject}""",
        file=sys.stderr,
    )

    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-c",
        "--power-config",
        action="store",
        dest="power_config",
        default=".gh-api-examples.conf",
        help="This is the config file to use to access variables for the power.",
    )
    parser.add_argument(
        "-e", "--extension", action="store", dest="extension", default="c"
    )

    parser.add_argument(
        "--issues",
        action="store",
        dest="number_of_issues",
        default=3,
        help="The number of issues to create.",
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
