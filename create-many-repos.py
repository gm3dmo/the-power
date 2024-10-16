import sys
import json
import logging
import time
import concurrent.futures
import urllib3
import argparse
import threading
import thepower
from pathlib import Path
from datetime import datetime

def make_request(i, args, http, token, counter, lock, total_time, batch_start_time):
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
        start_time = time.time()  # Record start time
        response = http.request('POST', url, body=params, headers=headers)
        end_time = time.time()  # Record end time
        duration = (end_time - start_time) * 1000  # Calculate duration in milliseconds

        if response.status == 201:
            with lock:
                counter[0] += 1
                total_time[0] += duration
                if counter[0] % 100 == 0:
                    batch_end_time = time.time()
                    batch_duration = (batch_end_time - batch_start_time[0]) * 1000  # Calculate duration in milliseconds
                    print(f"{counter[0]} repos created, time for last 100: {batch_duration:.2f} ms, total time taken: {total_time[0]:.2f} ms", file=sys.stderr)
                    batch_start_time[0] = batch_end_time  # Reset the start time for the next batch
        else:
            raise Exception(f"Failed to create repo {repo_name}, status code: {response.status}")
    except Exception as e:
        request_id = response.headers.get('x-github-request-id', 'N/A') if response else 'N/A'
        error_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{error_time}] Error creating repo {repo_name}: {e}, x-github-request-id: {request_id}", file=sys.stderr)


def main(args):
    loglevel = "INFO"
    logging.basicConfig(level=loglevel)
    logger = logging.getLogger(__name__)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')

    args.num_pools = 50
    args.max_workers = 20

    if args.number_of_repos is False:
        args.number_of_repos = int(power_config.get('dummy_section','number_of_repos'))

    if args.org is False:
        args.org = power_config.get('dummy_section','org').strip('"')

    if args.repo_prefix is False:
        args.repo_prefix = "default-prefix"  # Set a default prefix or raise an error

    logger.info(f"""creating: {args.number_of_repos} repos""")
    logger.info(f"""on host: {args.hostname}""")
    logger.info(f"""on org: {args.org}""")

    token = f"Bearer {args.GITHUB_TOKEN}"
    http = urllib3.PoolManager(num_pools=args.num_pools)
    ts = time.time()
    start = datetime.now()

    counter = [0]  # Initialize a counter list with one element
    total_time = [0.0]  # Initialize a total time list with one element
    lock = threading.Lock()  # Initialize a lock
    batch_start_time = [time.time()]  # Initialize the start time for the first batch

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.max_workers) as executor:
        executor.map(lambda x: make_request(x, args, http, token, counter, lock, total_time, batch_start_time), range(int(args.number_of_repos)))

    end = datetime.now()
    elapsed = end - start
    print(f"""elapsed time: {elapsed} to create {args.number_of_repos} repos""", file=sys.stderr)
    print(f"""{counter[0]} repos created, total time taken: {total_time[0]:.2f} ms""", file=sys.stderr)  # Print the number of repos created and total time taken


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
