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
        "User-Agent" : f"the-power-{i}"
    }

    username  = f"{args.user_prefix}-{i:07}"
    params = {
        "login": f"{username}",
        "email": f"{username}@example.com",
    }
    params = json.dumps(params)
    url =  f"{args.url}/admin/users"

    try:
        response = http.request('POST', url, body=params, headers=headers)
        #print(f"User {username} created successfully", file=sys.stderr)
    except Exception as e:
        print(f"Error creating user {username}: {e}", file=sys.stderr)

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

    token = f"Bearer {args.GITHUB_TOKEN}"
    http = urllib3.PoolManager(num_pools=10)
    ts = time.time()
    start = datetime.now()

    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        executor.map(lambda x: make_request(x, args, http, token), range(args.number_of_users_to_create_on_ghes))

    end = datetime.now()
    elapsed = end - start
    print(f"""elapsed time: {elapsed} to create {args.number_of_users_to_create_on_ghes} users""", file=sys.stderr)


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