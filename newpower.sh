#!/bin/bash

# Version: 0.1.2

# This script clones a fresh copy of the 'the-power' repository into a new directory.
# The name of the new directory should be provided as an argument when running this script.
# After cloning the repository, the script will call 'all-the-things.sh' to run a default build of 'the-power'.
#
# Usage: ./script.sh <new-directory-name>

# Check if script was run with --help
if [ "$1" == "--help" ]; then
    echo "Usage: ./script.sh <new-directory-name>"
    echo "Clones 'the-power' repository into a new directory and runs a default build."
    exit 0
fi

# Check if script was run with an argument
if [ -z "$1" ]; then
    echo "Error: No directory name provided."
    exit 1
fi

# Clone the repository
if ! git clone https://github.com/gm3dmo/the-power.git ~/the-power/$1; then
    echo "Error: Failed to clone repository."
    exit 1
fi

# Extract version number from this script
current_version=$(sed -n 's/^# Version: //p' "$0")

# Extract version number from the cloned script
cloned_version=$(sed -n 's/^# Version: //p' ~/the-power/$1/newpower.sh) || { echo "Error: Failed to extract version number from cloned script."; }

echo "The script may appear to hang here. Please be patient."

# Change to the new directory
cd ~/the-power/$1 || { echo "Error: Failed to change directory."; exit 1; }

# Create a Python virtual environment
if ! python3 -m venv myenv; then
    echo "Error: Failed to create virtual environment."
    exit 1
fi

# Activate the virtual environment
source myenv/bin/activate || { echo "Error: Failed to activate virtual environment."; exit 1; }

# Install the playwright package
if ! pip install playwright; then
    echo "Error: Failed to install playwright."
    exit 1
fi

# Run the all-the-things.sh script
if ! ~/the-power/$1/all-the-things.sh; then
    echo "Error: Failed to run all-the-things.sh."
    exit 1
fi

# Pull in generated files for variable usage below
. ~/the-power/$1/.gh-api-examples.conf
. ~/the-power/$1/shell-profile

# Set terminal colors
normal=$(tput sgr0)
highlight=$(tput setaf 2)

# Print success message
printf "${normal}Successfully installed the-power to ${highlight}~/the-power/%s${normal}\n" "$1"

# Print shell shortcuts

printf "\nThe following shell alias shortcuts are available:\n"
printf "${highlight}ch${normal}: open a new instance of chrome using profile #19 at http://%s\n" "$H"

if [ -n "$org" ] && [ -n "$repo" ]; then
    printf "${highlight}chrepo${normal}: open a new instance of chrome using profile #19 at http://%s/%s/%s\n" "$H" "$org" "$repo"
fi


printf "${highlight}chmona${normal}: open a new instance of chrome using profile #20 at http://%s\n" "$H"
printf "${highlight}ffx${normal}: open a new instance of firefox (if available) at http://%s\n" "$H"
printf "${highlight}edg${normal}: open a new instance of edge (if available) at http://%s\n" "$H"
printf "${highlight}pa${normal}: print the ghe-admin password of %s\n" "$H"
printf "${highlight}st${normal}: SSH to the primary GHES instance %s\n" "$H"

if [ -n "$replica_ip" ]; then
    printf "${highlight}sr${normal}: SSH to the replica GHES instance of %s at %s\n" "$H" "$replica_ip"
fi

printf "\nTo use these shortcuts temporarily for this shell session, run the following:\n"
printf "\n${highlight}cd ~/the-power/%s && source ~/the-power/%s/shell-profile\n" "$1" "$1"

# Compare the version numbers
if [ "$current_version" != "$cloned_version" ]; then
    printf "\n\n${highlight}Warning:${normal} Version number of the cloned newpower.sh (${highlight}%s${normal}) is different from your current local copy (${highlight}%s${normal}). You may wish to update your local copy." "$cloned_version" "$current_version"
fi
