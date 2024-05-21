#!/usr/bin/env python3

import argparse
import json
import logging
import pprint
import shlex
import thepower


def terraform_workspace_id(text):
    """Extracts Terraform Workspace ID and write it to JSON.

    Example input:

@kyanny
, :wave:
You've requested GHES 3.10.3 single-node resources in australiaeast on azure with setup.
You can follow your instance creation @ https://terraform.githubapp.com/app/ghes/workspaces/gheboot-kyanny-1716187058841/runs/run-PNAKUxRcwBjyNF1T. (If this is your first time launching a GHEBoot instance via Terraform you will need to log into Terraform Enterprise from the Okta tile before this link will work)
We've set the name of this request to gheboot-kyanny-1716187058841 and your Terraform workspace is: gheboot-kyanny-1716187058841 (ws-v8whx1M2tBoYcNeC) and we've used the key in position 0 in your profile in GitHub.com for SSH access to this instance.
Just FYI, the reqested instance(s) will expire on 2024-05-22.
    """

    lexer = shlex.shlex(text)
    lexer.whitespace_split = True
    lexer.whitespace = ' \t\n\r\f\v'
    tokens = list(lexer)

    # Terraform Workspace ID is the token three after "workspace"
    index = tokens.index("workspace")
    # Remove the parentheses
    workspace_id = tokens[index + 3].replace("(", "").replace(")", "")

    return {"terraform_workspace_id": workspace_id}


def main(args):
    text = ""
    if args.ghe_file == False:
        message="""Please paste below the output from gheboot informing you
        Terraform Workspace ID (ws-xxxxxx). When that's done press the return key twice to proceed:\n"""
        thepower.clear_screen()
        print(f"\033[93m\n\n{message}\033[0m\n")  
        lines = []
        while True:
            line = input()
            if line:
                lines.append(line)
            else:
                break
        text = '\n'.join(lines)
    else:
        # assume the file exists
        with open(args.ghe_file, "r") as f:
            text = f.read()

    environment = {}
    with open(args.environment_file, "r") as f:
        environment = json.loads(f.read())

    data = terraform_workspace_id(text)
    environment = {**environment, **data}
    with open(args.environment_file, "w") as f:
        f.write(json.dumps(environment))

    print(f"\033[92m")
    print("\n")
    thepower.print_progress_bar()
    print(f"""\n\nConverted Hubot output to "{args.environment_file}" file:\n""")
    with open(args.environment_file, "r") as f:
        j = json.loads(f.read())
        pprint.pprint(j)


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
