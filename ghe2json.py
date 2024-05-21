#!/usr/bin/env python3
"""
ghe2json command line tool to convert gheboot output to json.
"""

import string
import argparse
import logging
import logging.config
import thepower
import json
import pprint


def generate_template(environment):
    e = json.loads(environment)
    values = {}
    values['hostname'] =  e['hostname']
    values['password_recovery'] =  e['password_recovery']
    values['ip_replica'] = e['ip_replica'] or None
    t = string.Template(r"""H=$hostname

U=admin

replica_ip=$ip_replica

I=$U@$H

export U H I


function ch() {
# Start chrome with one the profiles you can list below:
# ls -l  ~/Library/Application\ Support/Google/Chrome/
# You will need to work out which profile is wich person
open -n -a "Google Chrome" --args --profile-directory="Profile 19" "http://$H"
}

function chrepo() {
# Start chrome with one the profiles you can list below:
# ls -l  ~/Library/Application\ Support/Google/Chrome/
# You will need to work out which profile is wich person
. ./.gh-api-examples.conf
open -n -a "Google Chrome" --args --profile-directory="Profile 19" "http://$H/$org/$repo"
}

function chmona() {
# In this on my mona user has a Profile 20:
open -n -a "Google Chrome" --args --profile-directory="Profile 20" "http://$H"
}

function ffx() {
open -a "Firefox"  "http://$H"
}

function edg() {
open -a "Microsoft Edge"  "http://$H"
}

function ve() {
    cat .ghe
}

function pa() {
  # This runs the ssh command on line 7 of the ghe output
  # to fetch the password from the ghe server.
  $password_recovery
}

function st() {
    # SSH onto the ghe server
    >&2 echo ssh to: $I
    ssh -o StrictHostKeyChecking=no -p122 $I
}

function sr() {
    # SSH onto the ghe server
    >&2 echo ssh to: $replica_ip
    ssh -o StrictHostKeyChecking=no -p122 admin@$replica_ip
}


export PATH="/usr/local/opt/curl/bin:$PATH"

export PS1="%m %F{yellow}:%1~%f $ "

""")


    return t.safe_substitute(values)





def main(args):
    text = ""
    if args.ghe_file == False:
        message="""Please paste below the output from gheboot informing you that the
appliance is ready (optionally paste in a token for an admin user
with all scopes set). When that's done press the return key twice to proceed:\n"""
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

    environment = (thepower.ghe2json(text))
    with open(args.environment_file, "w") as f:
        f.write(environment)


    t = generate_template(environment)
    with open('shell-profile', 'w') as f:
        f.write(t)
        
    print(f"\033[92m")
    print("\n")
    thepower.print_progress_bar()
    print(f"""\n\nConverted Hubot output to "{args.environment_file}" file:\n""")
    with open(args.environment_file, "r") as f:
        j = json.loads(f.read())
        pprint.pprint(j)
    print(f"{'='*80}")
    print("\n")
    message = """To create a PAT quick. In Chrome Open the developer console (Option + Command J):

 $$('input[type="checkbox"').map(i => i.checked = true)

"""
    print(f"\033[93m\n\n{message}\033[0m\n")  




            


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
