#!/usr/bin/env python3
"""
ghe2json command line tool to convert gheboot output to json.
"""

__author__ = "David Morris"
__version__ = "0.1.0"
__license__ = "GPL"

import os
import sys
import string
import argparse
import logging
import logging.config
from pathlib import Path
import subprocess
from datetime import datetime
import re
import thepower


def main(args):
    if args.ghe_file == False:
        print(f"""Reading ghe output from stdin. Please paste below:\n""")
        lines = []
        while True:
            line = input()
            if line:
                lines.append(line)
            else:
                break
        text = '\n'.join(lines)
        environment = (thepower.ghe2json(text))
        with open(args.environment_file, "w") as f:
            f.write(environment)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--ghe-file",
        action="store",
        dest="ghe_file",
        default=False,
    )
    parser.add_argument(
        "--environment-file",
        action="store",
        dest="environment_file",
        default="environment.json",
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

    logging.basicConfig(level=logging.INFO)
    logging.getLogger().handlers.clear()
    logger = logging.getLogger(__name__)
    console_handler = logging.StreamHandler()
    console_handler.setLevel(args.loglevel.upper())
    logger = logging.getLogger(__name__)
    logger.addHandler(console_handler)

    main(args)
