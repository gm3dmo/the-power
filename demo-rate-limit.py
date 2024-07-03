#!/usr/bin/env python3

"""
< x-ratelimit-limit: 5000
< x-ratelimit-remaining: 4998
< x-ratelimit-reset: 1719999372
< x-ratelimit-used: 2
< x-ratelimit-resource: core
"""

__author__ = "David Morris (gm3dmo@gmail.com)"

import datetime
import requests

def get_github_api_data(url, params=None):
    headers = {"Accept": "application/vnd.github.v3+json"}
    response_data = []
    response = requests.get(url, headers=headers, params=params)
    response_json = response.json()
    response_data.extend(response_json)

    if 'x-ratelimit-limit' in response.headers:
        print(f"""Allowed rate limit: {response.headers['x-ratelimit-limit']}""")
        if 'x-ratelimit-remaining' in response.headers:
            print(f"""Remaining rate limit: {response.headers['x-ratelimit-remaining']}""")
        if 'x-ratelimit-reset' in response.headers:
            reset_time = datetime.datetime.fromtimestamp(int(response.headers['x-ratelimit-reset']))
            seconds_to_wait_until_rate_limit_reset = reset_time - datetime.datetime.now()
            print(f"""Rate limit resets at : {reset_time}""")
            print(f"""Seconds to wait until rate limit resets: {int(seconds_to_wait_until_rate_limit_reset.total_seconds())}""")
            print(f"""Rate limit reset: {response.headers['x-ratelimit-reset']}""")
        if 'x-ratelimit-used' in response.headers:
            print(f"""Rate limit used: {response.headers['x-ratelimit-used']}""")
        if 'x-ratelimit-resource' in response.headers:
            print(f"""Rate limit resource: {response.headers['x-ratelimit-resource']}""")

    return response_data


def main():

    base_url = "https://api.github.com/users"
    params = {"state": "open"}
    issues_data = get_github_api_data(base_url, params=params)

if __name__ == "__main__":
    main()
