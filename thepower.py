#!/usr/bin/env python3
"""
Module Docstring
"""

__author__ = "Your Name"
__version__ = "0.1.0"
__license__ = "MIT"

import sys
import string
import os.path
import logging
import urllib
import json
import subprocess
import configparser
import shlex
from pathlib import Path
from urllib import request
import re


def ghe2json(text):
    """Converts the text output from gheboot to json"""
    lexer = shlex.shlex(text)
    lexer.wordchars += ".-"
    data = {}
    for token in lexer:
        if token == "GHE":
            # Extract the software version
            data["ghe_version"] = lexer.get_token()
            data["software_name"] = "GitHub Enterprise Server"
        elif token == "Azure":
            data["platform"] = token
            # Extract the VM type and region
            data["vm_type"] = lexer.get_token()
            [lexer.get_token() for _ in range(2)]
            data["region"] = lexer.get_token()
        elif token == "AWS":
            # Extract the VM type and region
            data["platform"] = token
            data["vm_type"] = lexer.get_token()
            [lexer.get_token() for _ in range(3)]
            data["region"] = lexer.get_token()
        elif token == "http":
            # Extract the HTTP URL
            l = [lexer.get_token() for _ in range(4)]
            s = "".join(l)
            data["access_urls"] = {"http": f"http{s}"}
            data["access_urls"]["hostname"] = l[3]
        elif token == "ssh":
            # Extract the SSH
            # ssh -p122 admin@gm3dmo-1682111193.gh-quality.net -- cat /data/user/common/
            port = lexer.get_token()
            user = lexer.get_token()
            lexer.get_token()
            host = lexer.get_token()
            l = [lexer.get_token() for _ in range(3)]
            s = "".join(l)
            print(s)
            data["access_urls"]["ssh"] = f"""{token} {port} {user}@{host}"""
        elif token == "IP":
            # Extract the IP address
            [lexer.get_token() for _ in range(2)]
            data["ip_address"] = lexer.get_token()
        elif token == "ssh":
            # Extract the password command
            data[
                "management_console_password_command"
            ] = f"{token} {lexer.get_token()} -- cat {lexer.get_token()}"
        elif token == "Server":
            # Server will automatically be terminated on 2023-04-23 21:23:51 UTC
            # Extract the termination date
            [lexer.get_token() for _ in range(5)]
            termination_date = lexer.get_token()
            l = [lexer.get_token() for _ in range(5)]
            termination_time = "".join(l)
            termination_tz = lexer.get_token()
            data[
                "termination_date"
            ] = f"""{termination_date}T{termination_time} {termination_tz}"""
        elif token.startswith("ghp_"):
            # Extract the token
            data["token"] = token
    return json.dumps(data, indent=2)


def token_validator(token: string):
    token_format_is_valid = False
    if token.startswith('gh') or token.startswith('github_pat_') or len(token) == 40:
        token_format_is_valid = True
    return token_format_is_valid


def get_webhook_url():
    webhook = False
    """ A visit to https://smee.io/new generates you a unique smee link
    < Location: https://smee.io/i9T6BorvnhBALFD
    """
    url = "https://smee.io/new"
    logging.warning(f"Requesting webhook from: {url}")
    webhook_url = None
    try:
       req = urllib.request.Request(url, data=None, headers={ 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'})
       response = urllib.request.urlopen(req)
       webhook_url = response.geturl()
    except Exception as e:
        logging.error(e)
        logging.error('smee.io is currently unavailable.')
    finally:
        logging.info(f"webhook url is: {webhook_url}")
        return webhook_url


def process_ghe_boot_file(filename):
    """
    We  can get all we want from the fourth line on the .ghe file:
    ssh -p122 admin@janedoe-0fb00b506b5e3e51f.ghe-test.net -- cat /data/user/common/qaboot-password
    """
    ghe_data = {}
    with open(filename, 'r') as reader:
        lines = reader.readlines()
        for counter, line in enumerate(lines):
            if re.search(r'Your GHE .* is ready', line):
                ghe_data['version'] = line.strip('\n')
            p = re.compile(r'ssh://admin@(.*):122')
            if p.search(line):
                ghe_data['hostname'] = p.search(line)[1]
            if re.search(r'IP address', line):
                ghe_data['ip_address'] = line.strip('\n')
            if re.search(r'terminated', line):
                ghe_data['termination_date'] = line.strip('\n')
            # match if it's the last line and it doesn't contain spaces
            if counter == len(lines) -1 and re.match(r'^\S+$', line):
                ghe_data['token'] = line.strip('\n')
    return ghe_data


def open_webhook_url_in_browser(hook_url, browser="chrome"):
    hook_location = f"""open -a "Google Chrome"  "{hook_url}" """
    logging.warning(f"Opening {hook_url} in {browser}.")
    try:
        subprocess.call(shlex.split(hook_location))
    except:
        pass
    finally:
        pass



def read_ghe_boot_file():
    home = Path.home()
    home_ghe = home / '.ghe'
    ghe = '.ghe'
    if os.path.exists('.ghe'):
        file_to_process = ghe
        return(process_ghe_boot_file(file_to_process))
    elif os.path.exists(home_ghe):
        file_to_process = home_ghe
        return(process_ghe_boot_file(file_to_process))
    else:
        return {}


def fake_ini_file(properties_file):
    with open(properties_file, 'r') as f:
        config_string = '[dummy_section]\n' + f.read()
        config = configparser.ConfigParser()
        config.read_string(config_string)
    return config


def read_dotcom_config(dotcom_config_file):
    dotcom_config_file =  Path(dotcom_config_file)
    if dotcom_config_file.is_file():
        dotcom_config = fake_ini_file(dotcom_config_file)
        logging.info(f"""Reading config file: {dotcom_config_file}""")
        logging.info(f"""Reading config app_id: {dotcom_config.getint('dummy_section','default_app_id')}""")
    else: 
        logging.warning(f"""No config file: {dotcom_config_file}""")
    return dotcom_config


if __name__ == "__main__":
    """ This is executed when run from the command line """
    main()
