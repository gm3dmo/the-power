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
from urllib.parse import urlparse
import re


def slugify(s):
  s = s.lower().strip()
  s = re.sub(r'[^\w\s-]', '', s)
  s = re.sub(r'[\s_-]+', '-', s)
  s = re.sub(r'^-+|-+$', '', s)
  return s


def ghe2json(text):
    """Converts the text output from gheboot to json"""

    lexer = shlex.shlex(text)
    lexer.whitespace_split = True
    lexer.whitespace = ' \t\n\r\f\v'
    tokens = list(lexer)
    
    # Find the index of "terminated" in the token list
    terminated_index = tokens.index("terminated")
    
    # Find the index of "GHE" or "GHES" in the token list
    try:
        ghe_index = tokens.index("GHE")
    except ValueError:
        ghe_index = tokens.index("GHES")
    
    # The version number should be the next token
    version = tokens[ghe_index + 1]
    
    # Find the index of the last occurrence of "ssh" in the token list
    ssh_index = len(tokens) - 1 - tokens[::-1].index("ssh")
    
    # If the next token after "ssh" is "-p122", extract the next six tokens
    if tokens[ssh_index+1] == "-p122":
        extracted_tokens = tokens[ssh_index+2:ssh_index+6]
        extracted_tokens.insert(0, tokens[ssh_index])
        extracted_tokens.insert(1, tokens[ssh_index+1])
        et = " ".join(extracted_tokens)
    
    td = 'unknown'
    
    termination_date = []
    # If the next token after "terminated" is "on", get the next token
    if tokens[terminated_index+1] == "on":
        if not tokens[terminated_index+2].endswith("Z"):
            next_three_tokens = tokens[terminated_index+2:terminated_index+5]
            termination_date.extend(next_three_tokens)
        else:
            termination_date.append(tokens[terminated_index+2])
    
    td = ' '.join(termination_date)
    
    ip_address = "unknown"
    ip_index= tokens.index("IP")
    
    if tokens[ip_index+2] == "is":
        if tokens[ip_index+3]:
            ip = tokens[ip_index+3]
            ip_address = ip 
    
    # hostname
    http_token = next((token for token in tokens if token.startswith("http://")), None)
    parsed_url = urlparse(http_token)
    hostname = (parsed_url.hostname)


    # Personal Access Token (PAT)
    pat = 'unknown'
    pat = next((token for token in tokens if token.startswith("ghp_")), None)
    
    
    print(f"""ghes_version: {version}""")
    print(f"""termination_date: {td}""")
    print(f"""ip_address: {ip_address}""")
    print(f"""hostname: {hostname}""")
    environment = {}
    environment['hostname'] = hostname
    environment['password_recovery'] = et
    environment['ip_address'] = ip_address
    environment['ghes_version'] = version
    environment['termination_date'] = td
    environment['token'] = pat

    return json.dumps(environment)


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
    ghe_data = {}
    with open(filename, 'r') as reader:
       ghe_data = json.load(reader)
           
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
    home_ghe = home / 'environment.json'
    ghe = 'environment.json'
    if os.path.exists(ghe):
        logging.info(f"Environment config detected: : {ghe}")
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
