import sys
import json
import logging
import time
import concurrent.futures
import urllib3
import argparse
import thepower
from pathlib import Path
from datetime import datetime

def make_request(i, args, http, token):
    headers = {
        "Authorization" : token,
        "Accept" :  "application/vnd.github.v3+json",
        "User-Agent" : f"pwr-repo-creator-{i}"
    }

    repo_name = f"""{args.repo_prefix}-{i:07}""" 

    params = {
               "name": repo_name,
               "description": f"this is a repo: {i}",
               "private": True
    }
    params = json.dumps(params)
    url =  f"""{args.url}/orgs/{args.org}/repos"""

    try:
        response = http.request('POST', url, body=params, headers=headers)
    except Exception as e:
        print(f"Error creating repo {repo_name}: {e}", file=sys.stderr)


def main(args):
    loglevel = "INFO"
    logging.basicConfig(level=loglevel)
    logger = logging.getLogger(__name__)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')

    if args.number_of_repos is False:
        args.number_of_repos = int(power_config.get('dummy_section','number_of_repos'))

    if args.org is False:
        args.org = power_config.get('dummy_section','org').strip('"')

    logger.info(f"""creating: {args.number_of_repos} repos""")
    logger.info(f"""on host: {args.hostname}""")
    logger.info(f"""on org: {args.org}""")


    token = f"Bearer {args.GITHUB_TOKEN}"
    http = urllib3.PoolManager(num_pools=12)
    ts = time.time()
    start = datetime.now()

    with concurrent.futures.ThreadPoolExecutor(max_workers=12) as executor:
        executor.map(lambda x: make_request(x, args, http, token), range(args.number_of_repos))

    end = datetime.now()
    elapsed = end - start
    print(f"""elapsed time: {elapsed} to create {args.number_of_repos} repos""", file=sys.stderr)


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
        help="the organization name."
    )

    args = parser.parse_args()

    main(args)