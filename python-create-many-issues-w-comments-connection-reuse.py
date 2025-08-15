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
from pathlib import Path
from datetime import datetime

def create_issue(conn, url, params, headers):
    conn.request('POST', url, params, headers=headers)
    r1 = conn.getresponse()
    data = r1.read()
    if r1.status == 201:
        issue_json = json.loads(data)
        return issue_json["number"]
    else:
        print(f"Failed to create issue: {r1.status} {data}")
        return None

def add_comment(conn, url, params, headers):
    conn.request('POST', url, params, headers=headers)
    r2 = conn.getresponse()
    r2.read()
    # optionally, check r2.status and handle errors

def main(args):

    loglevel = args.loglevel.upper()
    logging.basicConfig(level=loglevel)
    logger = logging.getLogger(__name__)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.extension = power_config.get('dummy_section','file_extension').strip('"')

    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')
    args.org = power_config.get('dummy_section','org').strip('\"')
    args.repo = power_config.get('dummy_section','repo').strip('\"')

    args.number_of_issues = int(args.number_of_issues) or int(power_config.get('dummy_section','number_of_issues'))
    args.comments_per_issue = int(args.comments_per_issue) or 0
    logger.info(f"creating: {args.number_of_issues} issues with {args.comments_per_issue} comments each")

    token = f"Bearer {args.GITHUB_TOKEN}"
    headers = {
               "Authorization" : token,
               "Accept" :  "application/vnd.github.v3+json",
               "User-Agent" : "the-power"
              }

    conn = http.client.HTTPSConnection(args.hostname)

    # time how long it takes to create the issues and comments
    start = datetime.now()
    for i in range(args.number_of_issues):
        issue = f"test-issue-{i:07}"
        params = {
                "title": f"issue test: {issue}",
                "body": f"issue test: {issue}",
               }
        params_str = json.dumps(params)
        url =  f"{args.url}/repos/{args.org}/{args.repo}/issues"
        try:
           logger.debug(f"sending request {i}")
           issue_number = create_issue(conn, url, params_str, headers)
           if issue_number and args.comments_per_issue > 0:
               for c in range(args.comments_per_issue):
                   comment_body = {
                       "body": f"Comment {c+1} for {issue}"
                   }
                   comment_str = json.dumps(comment_body)
                   comment_url = f"{args.url}/repos/{args.org}/{args.repo}/issues/{issue_number}/comments"
                   try:
                       add_comment(conn, comment_url, comment_str, headers)
                       logger.debug(f"Added comment {c+1} to issue {issue_number}")
                   except Exception as ce:
                       print(f"Error adding comment {c+1} to issue {issue_number}: {ce}")
        except Exception as e:
           print(f"Error: {e}") 

    end = datetime.now()
    elapsed = end - start
    print(f"elapsed time: {elapsed} to create {args.number_of_issues} issues with {args.comments_per_issue} comments each", file=sys.stderr)

    conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "--issues",
        action="store",
        dest="number_of_issues",
        default=3,
        help="The number of issues to create.",
    )
    parser.add_argument(
        "--comments-per-issue",
        action="store",
        dest="comments_per_issue",
        default=2,
        help="Number of comments to add per issue.",
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
