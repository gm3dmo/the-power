#!/usr/bin/env python3
"""
Module Docstring
"""

__author__ = "Your Name"
__version__ = "0.1.0"
__license__ = "MIT"

import random
import sys
import string
import os.path
import logging
import time
import urllib
import json
import subprocess
import configparser
import shlex
import hashlib
import base64
from pathlib import Path
from urllib import request
from urllib.parse import urlparse
import re


def hash_and_encode(token):
    """Creates the hashed token for a PAT. See the guidance at [generating a sha 265 hash value for a token](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/identifying-audit-log-events-performed-by-an-access-token#generating-a-sha-256-hash-value-for-a-token)
    """
    # Hash the token using SHA-256
    sha256_hash = hashlib.sha256(token.encode()).digest()
    # Base64 encode the binary hash
    base64_encoded = base64.b64encode(sha256_hash).decode()
    return base64_encoded


def run_password_recovery(password_recovery_command):
    if password_recovery_command:
        process = subprocess.run(password_recovery_command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        s = process.stdout.decode()
        s = s.rstrip('\n')
        return s
    else:
        return "No password recovery command found"


def slugify(s):
  s = s.lower().strip()
  s = re.sub(r'[^\w\s-]', '', s)
  s = re.sub(r'[\s_-]+', '-', s)
  s = re.sub(r'^-+|-+$', '', s)
  return s


def ghe2json(text, ssh=True):
    """Converts the text output from gheboot to json.
    
    Example input:

@kyanny
, Your requested GHES 3.10.3 single-node resources in  australiaeast on azure (named: gheboot-kyanny-1716187058841) true are ready!
This is a(n) SINGLE-NODE deployment of GHES
Access the UI at:
  http://kyanny-mclq08.ghe-test.com
Access the instance via SSH at:
  ssh://admin@gheboot-all-kyanny-0-mclq08.ghe-test.com:122
The instances in this deployment are:
  gheboot-all-kyanny-0-mclq08.ghe-test.com
You can get the Management Console and 'ghe-admin' user's password by running:
ssh -p122 admin@gheboot-all-kyanny-0-mclq08.ghe-test.com -- cat /data/user/common/gheboot-password
This Server will automatically be terminated on 2024-05-22T06:38:39Z    
    """

    lexer = shlex.shlex(text)
    lexer.whitespace_split = True
    lexer.whitespace = ' \t\n\r\f\v'
    tokens = list(lexer) 

    # Find the index of "terminated" in the token list
    termination_date = []
    try: 
       terminated_index = tokens.index("terminated")
    except ValueError:
        terminated_index = False

    if terminated_index == False:
       td = 'unknown'
    else:
        # If the next token after "terminated" is "on", get the next token
        if tokens[terminated_index+1] == "on":
            if not tokens[terminated_index+2].endswith("Z"):
                next_three_tokens = tokens[terminated_index+2:terminated_index+5]
                termination_date.extend(next_three_tokens)
            else:
                termination_date.append(tokens[terminated_index+2])
    td = ' '.join(termination_date)
    

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
    
    # hostname
    http_token = next((token for token in tokens if token.startswith(("http://", "https://"))), None)
    parsed_url = urlparse(http_token)
    hostname = (parsed_url.hostname)

    # Admin user
    try:
        admin_index = tokens.index("(Log") 
        admin_user = str(tokens[admin_index+3]).strip("'")
    except ValueError:
        admin_user = "unknown"
    
    try: 
        admin_index = tokens.index("Console")
        admin_user = str(tokens[admin_index+2]).strip("'")
    except ValueError:
        admin_user = "unknown"


    # Personal Access Token (PAT)
    pat = 'unknown'
    pat = next((token for token in tokens if token.startswith("ghp_")), '')

    #IP address instances: 10.0.0.1, 10.0.0.2
    # 
    # Find the index of "IP" in the token list
    ip_addresses = []
    try:
        ip_index = tokens.index("IP")
        ips = next((token for token in tokens if token.startswith("IP")), '')
    except ValueError:
        ip_index = False
        ips = "none"


    if ip_index == False:
        ip_address = False
        primary = None
        secondary = None
        ip_addresses = [primary, secondary]
    else:
        ip_address = "none"
        ip_addresses.append(ip_address)
        primary=ip_address
        secondary = "none"
        if tokens[ip_index+1] == "address":
            if tokens[ip_index+2] == "is":
                ip_address = tokens[ip_index+3]
                print(f"this is a single host installation: {ip_address}") 
                ip_addresses.append(ip_address)
                primary=ip_address
                secondary = "none"
            elif tokens[ip_index+2] == "instances:":
                primary = str(tokens[ip_index+3]).strip(",")
                secondary = str(tokens[ip_index+4])
                ip_addresses.append(primary)
                ip_addresses.append(secondary)

    
    # password
    if ssh == True:
        pw = run_password_recovery(et)
    else:
        pw = "unknown"

 
    
    environment = {}
    environment['hostname'] = hostname
    environment['password_recovery'] = et
    environment['ghes_version'] = version
    environment['termination_date'] = td
    environment['token'] = pat
    environment['mgmt_password'] = pw
    environment['admin_password'] = pw
    environment['ip_addresses'] = ip_addresses
    environment['ip_primary'] = primary
    environment['ip_replica'] = secondary
    environment['admin_user'] = admin_user
    environment['token_generate_url'] = f"https://{hostname}/settings/tokens/new"

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
        logging.debug(f"Environment config detected: : {ghe}")
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


def clear_screen():
    # Check if the operating system is Windows
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')


def print_progress_bar():
    total_steps = 10  # Number of steps in the progress bar
    progress_symbol = "="
    empty_symbol = " "
    progress_bar_length = 50  # Length of the progress bar

    print("Converting Hubot output...")
    for step in range(total_steps + 1):
        # Calculate the percentage of completion
        percent_complete = step / total_steps
        progress_length = int(percent_complete * progress_bar_length)
        
        # Construct the progress bar string
        progress_bar = progress_symbol * progress_length
        empty_space = empty_symbol * (progress_bar_length - progress_length)
        progress_display = f"[{progress_bar}{empty_space}] {percent_complete * 100:.2f}%"
        
        # Print the progress bar
        sys.stdout.write(f"\r{progress_display}")
        sys.stdout.flush()
        
        # Sleep for a random amount of time less than 0.4 seconds to simulate work
        time.sleep(random.uniform(0, 0.4))
    
# Call the function to display the progress bar


if __name__ == "__main__":
    """ This is executed when run from the command line """
    main()
