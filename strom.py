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
    conn.request("POST", url, params, headers=headers)
    r1 = conn.getresponse()
    r1.read()


def submit(conn, url, params, headers):
    conn.request("POST", url, params, headers=headers)
    try:
        response = conn.getresponse()
        response.read()
        return response
    # handle the exception
    except http.client.RemoteDisconnected:
        logging.error("RemoteDisconnected")
        sys.exit(1)

    


if __name__ == "__main__":
    main(args)
