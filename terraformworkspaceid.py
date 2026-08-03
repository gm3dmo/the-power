#!/usr/bin/env python3

import argparse
import json
import logging
import pprint
import re
import thepower


def terraform_workspace_id(text):
    """Extracts Terraform Workspace ID and write it to JSON.

    Example input (older gheboot notification format):

@kyanny
, :wave:
You've requested GHES 3.10.3 single-node resources in australiaeast on azure with setup.
You can follow your instance creation @ https://terraform.githubapp.com/app/ghes/workspaces/gheboot-kyanny-1716187058841/runs/run-PNAKUxRcwBjyNF1T. (If this is your first time launching a GHEBoot instance via Terraform you will need to log into Terraform Enterprise from the Okta tile before this link will work)
We've set the name of this request to gheboot-kyanny-1716187058841 and your Terraform workspace is: gheboot-kyanny-1716187058841 (ws-v8whx1M2tBoYcNeC) and we've used the key in position 0 in your profile in GitHub.com for SSH access to this instance.
Just FYI, the reqested instance(s) will expire on 2024-05-22.

    Example input (newer gheboot notification format):

@kyanny, Your gheboot workspace gheboot-kyanny-3-21-3-standalone-0fd7d1e8 has been created with ID ws-K7Km2WgPVYk3GWyG in Terraform Enterprise and is being configured for your GHES instance(s).
    """

    # Match the ID directly rather than relying on its position relative to
    # surrounding wording, since the notification wording varies between formats.
    match = re.search(r"\bws-[A-Za-z0-9]+\b", text)
    if not match:
        raise ValueError("Could not find a Terraform workspace ID (ws-XXXX) in the input")

    return {"terraform_workspace_id": match.group(0)}


def main(args):
    text = ""
    if args.ghe_file == False:
        message="""Please paste below the output from gheboot informing you
        Terraform Workspace ID (ws-xxxxxx). When that's done press the return key twice to proceed:\n"""
        thepower.clear_screen()
        print(f"\033[93m\n\n{message}\033[0m\n")  
        lines = []
        empty_line_count = 0
        while True:
            line = input()
            if line:
                # Reset empty line counter and add any skipped blank lines back
                for _ in range(empty_line_count):
                    lines.append('')
                empty_line_count = 0
                lines.append(line)
            else:
                empty_line_count += 1
                if empty_line_count >= 2:
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
