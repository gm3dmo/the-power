#!/usr/bin/env python3
"""
Generate the hashed token from a PAT:

https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/identifying-audit-log-events-performed-by-an-access-token

"""

__author__ = "David Morris (gm3dmo@gmail.com)"

import os
import sys
import thepower


def main():
    token_value = sys.argv[1] 
    hashed_token = thepower.hash_and_encode(token_value)
    print(hashed_token)


if __name__ == "__main__":
    """ This is executed when run from the command line """
    main()
