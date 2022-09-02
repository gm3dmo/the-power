#!/usr/bin/env python3
"""
Module Docstring
"""

__author__ = "Your Name"
__version__ = "0.1.0"
__license__ = "MIT"

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


class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


def main(args):

    t = string.Template(
        """# For GHE Server only
#set -a
path_prefix=${path_prefix}
graphql_path_prefix=${graphql_path_prefix}

# GHES Specific settings
number_of_users_to_create_on_ghes=${number_of_users_to_create_on_ghes}
U=ghe-admin
admin_user=${admin_user}
admin_password=""

token=${token}
hostname=${hostname}
auth_header="Authorization: token ${token}"

enterprise="${enterprise_name}"
org="${org}"
repo="${repo_name}"
default_repo_visibility="private"
repo_secret_name="REPOSITORY_SECRET_001"
allow_auto_merge="${allow_auto_merge}"

organizations="site-b"
mail_domain="example.com"

team="Justice League"
team_slug="justice-league"
team_members="${team_members}"
team_admin="${team_admin}"
team_privacy="closed"
team_permission="admin"

org_owner="${org_owner}"
org_members="${org_members}"
default_committer="${default_committer}"
default_issue_id=1
default_pull_request_id=2
per_page=30
default_check_run_id=1
default_org_webhook_id=1

org_secret_name="ORGANIZATION_SECRET001"


branch_name="new_branch"
protected_branch_name="${base_branch}"
required_approving_reviewers=1
required_status_check_name="ci-test/this-check-is-required"
enforce_admins="false"
base_branch=${base_branch}

webhook_url=${webhook_url}
my_ssh_pub_key=~/.ssh/id_rsa.pub

# Pre-receive hook GitHub Enteprise Server only
pre_receive_hook_name=demo-pre-receive-hook
pre_receive_hook_repo=hook-repo
pre_receive_environment_id=1
pre_receive_hook_script=pre-receive-hook.sh
pre_hook_environment=default
pre_hook_enforcement=enabled
pre_hook_allow_downstream=true


# GPG Key
# To export your pub key:
# gpg --export -a "key_name" > public.key
my_gpg_pub_key=~/.gnupg/public.key

# Environments
default_environment_name="environment_1"
environment_secret_name="ENVIRONMENT_SECRET_001"

# Packages
default_package_type="container"

#Deployments
default_deployment_id=1

# Make the-power work same config variables as octo
GITHUB_TOKEN=${token}
GITHUB_API_BASE_URL=https://${hostname}${path_prefix}
GITHUB_APIV4_BASE_URL=https://${hostname}${graphql_path_prefix}

# GitHub App Tiny App
# Set private_pem_file name to the private key you've generated and downloaded..
private_pem_file=${private_key_pem_file}
# When working with the power in a codespace you may need a path like:
#private_pem_file=../../workspaces/the-power/ft-testapp.2022-03-23.private-key.pem
# The App ID: value at https://github.com/organizations/<org>/settings/apps/<appname>
default_app_id=${default_app_id}
# https://github.com/organizations/<org>/settings/installations/<installation_id>
default_installation_id=${default_installation_id}
# The Client ID is used when using the device authentication flow
client_id=$client_id

# GitHub Actions
enterprise_shr_group_name="my-enterprise-self-hosted-runners"

# curl flags for timing testing etc.
# example:
# curl_custom_flags="-kso /dev/null --write-out '%{json}'"
# default is ""
curl_custom_flags="${curl_custom_flags}"

# Self hosted runner setup
runner_version=${runner_version}
runner_os=${runner_os}
runner_platform=${runner_platform}

## Default values for scripts that generate many of a
number_of_orgs=${number_of_orgs}
number_of_repos=${number_of_repos}
number_of_branches=${number_of_branches}
repo_prefix="testrepo"
org_prefix="testorg"
user_prefix="testuser"
branch_prefix="testbranch"
file_prefix="testfile"
file_extension="c"

# Dispatcher
pool_size=10


# Legacy Oauth experiments section
x_client_id="<your oauth app client_id here>"
client_secret="<your oauth app client secret here>"
fingerprint="fingerprint1"
authorization_id=1

"""
    )

    ghe_config = thepower.read_ghe_boot_file()

    args.path_prefix = "/api/v3"
    args.graphql_path_prefix = "/api/graphql"
    args.org_owner = "mona"
    args.org_members = "mona"
    token_validation ="strict"

    # use "\" for these so that they get written to the conf
    # file including quotes:

    if args.dotcom_config != "":
        dotcom_config = thepower.read_dotcom_config(args.dotcom_config)
        logger.info(f"""config: {dotcom_config}""")
        ghe_config["hostname"] = dotcom_config.get("dummy_section", "hostname")
        ghe_config["token"] = dotcom_config.get("dummy_section", "token")
        args.org = dotcom_config.get("dummy_section", "org")
        args.default_app_id = dotcom_config.get("dummy_section", "default_app_id")
        args.default_installation_id = dotcom_config.get(
            "dummy_section", "default_installation_id"
        )
        args.client_id = dotcom_config.get("dummy_section", "client_id")
        args.team_members = dotcom_config.get("dummy_section", "team_members")
        args.team_admin = dotcom_config.get("dummy_section", "team_admin")
        args.org_owner = dotcom_config.get("dummy_section", "org_owner")
        args.org_members = dotcom_config.get("dummy_section", "org_members")
        args.default_committer = dotcom_config.get("dummy_section", "default_committer")
        args.private_pem_file = dotcom_config.get("dummy_section", "private_pem_file")

    if args.hostname != "":
        logger.info(f"GitHub hostname = {args.hostname}")
    elif "hostname" in ghe_config:
        args.hostname = ghe_config["hostname"]
    else:
        args.hostname = input(f"Enter GitHub hostname: ")

    if args.hostname == "api.github.com":
        args.path_prefix = ""
        args.graphql_path_prefix = "/graphql"
    else:
        # Set the path up for a GHES server
        default_app_id = 1
        default_installation_id = 1
        client_id = 1

    if args.token != "":
        logger.info(f"Token = *******")
    elif "token" in ghe_config:
        args.token = ghe_config["token"]
    else:
        args.token = input(f"Enter Personal Access Token: ")

    assert thepower.token_validator(args.token)


    if args.org != "":
        logger.info(f"Org = {args.org}")
    else:
        args.org = input(f"Enter Org name: ")

    # If configuring a GitHub App:
    if args.configure_github_app != "no":
        if args.app_id != "":
            logger.info(f"default_app_id = {args.app_id}")
        else:
            args.app_id = input(f"Enter App Id ({args.app_id}): ") or args.app_id

        if args.installation_id != "":
            logger.info(f"default_installation_id = {args.installation_id}")
        else:
            args.installation_id = (
                input(f"Enter Installation Id ({args.installation_id}): ")
                or args.installation_id
            )

        if args.client_id != "":
            logger.info(f"client_id = {args.client_id}")
        else:
            args.client_id = input(f"Enter Client Id: ")

        # Private key
        if args.private_pem_file != "":
            logger.info(f"private_key_pem_file = {args.private_pem_file}")
        else:
            args.private_key_pem_file = input(
                f"Enter path relative from home to app private key: "
            )

    if args.webhook_url == "smee":
        webhook_url = thepower.get_webhook_url()
        if webhook_url is None:
            webhook_url = input(f"Enter webhook URL: ")

        args.webhook_url = webhook_url
        if re.match(r"^https?://", args.webhook_url):
            thepower.open_webhook_url_in_browser(args.webhook_url)
        else:
            logger.info(
                "No webhook URL supplied. You can still set a webhook URL in .gh-api-examples.conf file."
            )
    elif args.webhook_url:
        logger.info(f"Webhook URL = {args.webhook_url}")
    else:
        args.webhook_url = input(f"Enter webhook url: ")

    values = {
        "token": args.token,
        "hostname": args.hostname,
        "path_prefix": args.path_prefix,
        "graphql_path_prefix": args.graphql_path_prefix,
        "webhook_url": args.webhook_url,
        "private_pem_file": args.private_pem_file,
        "org": args.org,
        "enterprise_name": args.enterprise_name,
        "base_branch": args.base_branch,
        "default_app_id": args.app_id,
        "default_installation_id": args.installation_id,
        "private_key_pem_file": args.private_pem_file,
        "client_id": args.client_id,
        "admin_user": args.admin_user,
        "team_members": args.team_members,
        "team_admin": args.team_admin,
        "org_owner": args.org_owner,
        "org_members": args.org_members,
        "default_committer": args.default_committer,
        "repo_name": args.repo_name,
        "number_of_users_to_create_on_ghes": args.number_of_users_to_create_on_ghes,
        "runner_version": args.runner_version,
        "runner_os": args.runner_os,
        "runner_platform": args.runner_platform,
        "number_of_orgs": args.number_of_orgs,
        "number_of_repos": args.number_of_repos,
        "number_of_branches": args.number_of_branches,
        "curl_custom_flags": args.curl_custom_flags,
        "allow_auto_merge": args.allow_auto_merge,
    }

    out_filename = ".gh-api-examples.conf"

    try:
        with open(out_filename, "w") as out_file:
            out_file.write(t.substitute(values))
            logger.info(
                f"\n{bcolors.OKGREEN}Configuration run is complete. Created {out_filename}"
            )
    except Exception as e:
        logger.warn(f"\n{bcolors.WARNING}Configuration run failed. {e}")

    cmd = f"""./{args.primer}"""
    logger.info(f"\n{bcolors.OKGREEN}Launching primer command: {args.primer}")
    # Now run the primer script to execute whatever task is wanted for this particular thing
    # can be useful when creating a container that executes some repetive task.
    subprocess.run(cmd, shell=True, check=True)
    logger.info(
        f"\n{bcolors.OKBLUE}========================================================="
    )


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--org", action="store", dest="org", default="acme")
    parser.add_argument(
        "-b", "--base_branch", action="store", dest="base_branch", default="main"
    )
    parser.add_argument(
        "-d",
        "--configure-app",
        action="store",
        dest="configure_github_app",
        default="no",
    )
    parser.add_argument("-a", "--app-id", action="store", dest="app_id", default=1)
    parser.add_argument(
        "-i", "--installation-id", action="store", dest="installation_id", default=1
    )
    parser.add_argument(
        "-e", "--client-id", action="store", dest="client_id", default=""
    )
    parser.add_argument(
        "-u", "--admin-user", action="store", dest="admin_user", default="ghe-admin"
    )
    parser.add_argument(
        "-w",
        "--webhook-url",
        action="store",
        dest="webhook_url",
        default="smee",
        help="Set this if you want to provide your own webhook url.",
    )
    parser.add_argument(
        "--number-of-users",
        action="store",
        dest="number_of_users_to_create_on_ghes",
        default=4,
        help="Number of users to create on GHES systems.",
    )
    parser.add_argument(
        "--runner-version",
        action="store",
        dest="runner_version",
        default="v2.294.0",
        help="Version of self hosted runner. Be sure to use the tag like this: `v2.294.0`",
    )
    parser.add_argument(
        "--runner-os",
        action="store",
        dest="runner_os",
        default="osx",
        help="OS for self hosted runner.",
    )
    parser.add_argument(
        "--runner-platform",
        action="store",
        dest="runner_platform",
        default="x64",
        help="CPU platform for self hosted runner",
    )
    parser.add_argument(
        "-c",
        "--copy-config",
        action="store",
        dest="dotcom_config",
        default="",
        help="Set this for github.com config",
    )
    parser.add_argument(
        "-r",
        "--repo-name",
        action="store",
        dest="repo_name",
        default="testrepo",
        help="Provide a repository name.",
    )
    parser.add_argument(
        "-n",
        "--hostname",
        action="store",
        dest="hostname",
        default="",
        help="Provide a fully qualified hostname/IP Address for a GHES appliance or use the default api.github.com",
    )
    parser.add_argument(
        "-t",
        "--token",
        action="store",
        dest="token",
        default="",
        help="Provide a personal access token.",
    )
    parser.add_argument(
        "-l",
        "--loglevel",
        action="store",
        dest="loglevel",
        default="info",
        help="Set the log level",
    )
    parser.add_argument(
        "-p",
        "--primer",
        action="store",
        dest="primer",
        default="list-user.sh",
        help="The name of a primer script which will be executed when configuration is complete",
    )
    parser.add_argument(
        "--private-pem-file",
        action="store",
        dest="private_pem_file",
        default="",
        help="The location of the apps private key (pem) file.",
    )
    parser.add_argument(
        "--number-of-orgs",
        action="store",
        dest="number_of_orgs",
        default=3,
        help="The number of orgs for the bulk creators to create.",
    )
    parser.add_argument(
        "--number-of-repos",
        action="store",
        dest="number_of_repos",
        default=3,
        help="The number of repos for the bulk creators to create.",
    )
    parser.add_argument(
        "--number-of-branches",
        action="store",
        dest="number_of_branches",
        default=10,
        help="The number of branches for the bulk creators to create.",
    )
    parser.add_argument(
        "--team-members",
        action="store",
        dest="team_members",
        default="mona hubot mario luigi",
        help="The members of your team.",
    )
    parser.add_argument(
        "--team-admin",
        action="store",
        dest="team_admin",
        default="mona",
        help="The admin of your team.",
    )
    parser.add_argument(
        "--default-committer",
        action="store",
        dest="default_committer",
        default="hubot",
        help="The user who will make default actions such as create commits, be assigned issues.",
    )
    parser.add_argument(
        "--allow-auto-merge",
        action="store",
        dest="allow_auto_merge",
        default="true",
        help="allow auto merge"
    )
    parser.add_argument(
        "--enterprise-name",
        action="store",
        dest="enterprise_name",
        default="",
        help="The name of your enterprise.",
    )
    parser.add_argument(
        "--custom-curl-flags",
        action="store",
        dest="curl_custom_flags",
        default="--no-progress-meter",
        help="curl custom flags.",
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
