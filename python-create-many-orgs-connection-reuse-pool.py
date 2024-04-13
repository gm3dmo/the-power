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
        "User-Agent" : f"pwr-org-creator-{i}"
    }

    org_name = f"{args.org_prefix}-{i:07}"
    params = {
                "login" : org_name,
                "profile_name" : f"{org_name} A Test Organization.",
                "admin" : f"{args.admin_user}"
    }
    params = json.dumps(params)
    #print(f"Creating params {params}", file=sys.stderr)
    url =  f"""{args.url}/admin/organizations"""

    try:
        response = http.request('POST', url, body=params, headers=headers)
    except Exception as e:
        print(f"Error creating org {org_name}: {e}", file=sys.stderr)


def main(args):
    loglevel = "INFO"
    logging.basicConfig(level=loglevel)
    logger = logging.getLogger(__name__)

    power_config = thepower.read_dotcom_config(args.power_config)
    args.url = power_config.get('dummy_section','GITHUB_API_BASE_URL')
    args.hostname = power_config.get('dummy_section','hostname')
    args.path_prefix = power_config.get('dummy_section','path_prefix')
    args.GITHUB_TOKEN = power_config.get('dummy_section','GITHUB_TOKEN')

    args.admin_user = str(args.admin_user) or str(power_config.get('dummy_section','admin_user').strip('\"'))
    if args.org_prefix is None:
        args.org_prefix = str(power_config.get('dummy_section','org_prefix').strip('\"'))

    args.number_of_orgs = int(args.number_of_orgs) or int(power_config.get('dummy_section','number_of_orgs').strip('\"'))

    logger.info(f"""creating: {args.number_of_orgs} orgs""")
    logger.info(f"""on host: {args.hostname}""")

    token = f"Bearer {args.GITHUB_TOKEN}"
    http = urllib3.PoolManager(num_pools=10)
    ts = time.time()
    start = datetime.now()

    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        executor.map(lambda x: make_request(x, args, http, token), range(args.number_of_orgs))

    end = datetime.now()
    elapsed = end - start
    print(f"""elapsed time: {elapsed} to create {args.number_of_orgs} orgs""", file=sys.stderr)


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