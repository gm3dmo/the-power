#!/usr/bin/env python3

import base64
import argparse
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
    args = parser.parse_args()

    string = args.infile.read()
    encoded = base64.standard_b64encode(string.encode('utf-8'))
    print(encoded.decode('utf-8'))

if __name__ == "__main__":
    main()
