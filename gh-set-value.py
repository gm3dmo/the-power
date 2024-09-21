
import sys
import logging
import logging.config
import pprint
import thepower
import argparse

def main(args):

    #dotcom_config = thepower.read_dotcom_config(args.dotcom_config)
    #logger.info(f"""config: {dotcom_config}""")

    # Read the .gh-api-examples.conf file
    with open(args.dotcom_config, 'r') as file:
        lines = file.readlines()

    # Process each line
    updated_lines = []
    key_found = False
    for line in lines:
        if line.strip().startswith(f"{args.config_key}="):
            updated_lines.append(f"{args.config_key}={args.config_value}\n")
            key_found = True
        else:
            updated_lines.append(line)

    # If the key was not found, add it to the end
    if not key_found:
        updated_lines.append(f"{args.config_key}={args.config_value}\n")

    # Write the updated lines back to the file
    with open(args.dotcom_config, 'w') as file:
        file.writelines(updated_lines)

    # Print the entire updated configuration
    logger.debug("Updated config:")
    for line in updated_lines:
        logger.debug(line.strip())



if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--config-file",
        action="store",
        dest="dotcom_config",
        default=".gh-api-examples.conf",
        help="Set this for github.com config", 
    )
    parser.add_argument(
        "--key",
        action="store",
        dest="config_key",
        default="",
        help="Key to set in config file", 
    )
    parser.add_argument(
        "--value",
        action="store",
        dest="config_value",
        default="",
        help="New value for key in config file", 
    )
    parser.add_argument(
        "--loglevel",
        action="store",
        dest="loglevel",
        default="info",
        help="Set the log level",
    )

    args = parser.parse_args()

    logging.getLogger().handlers.clear()
    logging.basicConfig(level=logging.INFO, format='%(message)s')
    logger = logging.getLogger(__name__)

    main(args)
