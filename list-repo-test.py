#! /usr/bin/env python3 

import requests
import json
import time
import argparse
import logging
import logging.config
from datetime import datetime
import thepower

def main(args):
    power_config = thepower.read_dotcom_config(args.power_config)
    args.owner = args.org
    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.hostname = power_config.get('dummy_section','hostname')

    # Get the PAT from the environment file
    with open('environment.json', 'r') as file:
        env = json.load(file)

    args.token = env['token']
    args.token8 = args.token[-8:]
    logger.debug(f"GitHub Token last eight = {args.token8}")

    while True:
        try:
            repo_info = get_github_repo(args.owner, args.repo, args.hostname, args.token)
        except Exception as e:
            print(f"Error: {e}")
        time.sleep(args.delay / 1000.0)  # Convert milliseconds to seconds


def get_github_repo(owner, repo, hostname, token):
    url = f"https://{hostname}/api/v3/repos/{owner}/{repo}"
    headers = {
        "Accept": "application/vnd.github.v3+json",
        "Accept-Encoding": None,
        "Authorization": f"Bearer {token}"
    }

    start_time = time.time()
    response = requests.get(url, headers=headers)
    end_time = time.time()

    request_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    duration = (end_time - start_time) * 1000  # Duration in milliseconds
    request_id = response.headers.get('x-github-request-id', 'N/A')
    content_length = response.headers.get('content-length', 'N/A')
    etag = response.headers.get('ETag', 'N/A')

    log_entry = {
        "time": request_time,
        "status": response.status_code,
        "duration_ms": f"{duration:.2f}",
        "request_id": request_id,
        "content_length": content_length,
        "hostname": hostname,
        "Etag": etag 
    }
    logger.debug(log_entry)

    with open("request_log.json", "a") as log_file:
        log_file.write(json.dumps(log_entry) + "\n")

    print(json.dumps(log_entry), end='')

    if 200 <= response.status_code < 300:
        return response.json()
    else:
        raise Exception(f"Failed to fetch repository info: {response.status_code}, {response.text}")

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--org", action="store", dest="org", default="acme", help="The name or an (org)anization to target")
    parser.add_argument("--repo", action="store", dest="repo", default="testrepo", help="The name of a (repo)sitory to target")
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for The Power")
    parser.add_argument(
        "--loglevel",
        action="store",
        dest="loglevel",
        default="info",
        help="Set the log level",
    )
    parser.add_argument(
        "--delay",
        action="store",
        dest="delay",
        type=int,
        default=1000,
        help="Delay between requests in milliseconds",
    )

    args = parser.parse_args()

    logger = logging.getLogger(__name__)
    console_handler = logging.StreamHandler()
    console_handler.setLevel(args.loglevel.upper())

    # Set formatter for the console handler
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    console_handler.setFormatter(formatter)

    logger.addHandler(console_handler)
    logger.setLevel(args.loglevel.upper())
    logger.propagate = False  # Prevent duplicate log entries

    main(args)
