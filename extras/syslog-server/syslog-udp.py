#!/usr/bin/env python3
"""
UDP Listener/printer
"""

__author__ = "David Morris (gm3dmo@gmail.com)"

import argparse
import socket

def main():

    hostname= '0.0.0.0'
    port = 10514

    # Uncomment "wanted_string" and set it to a desired value to match and print
    # only lines which match the wanted string.
    # wanted_string ="github_audit"

    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.bind((hostname, port))
        print(f"""UDP Syslog listener on {hostname}:{port}""")

        while True:
            data = s.recv(1024)
            if wanted_string:
                if wanted_string in str(data):
                    print(data)
            else:
                print(data)
            if not data:
                break

if __name__ == "__main__":
    main()
