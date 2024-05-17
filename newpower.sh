#!/bin/bash

# This script clones a fresh copy of the 'the-power' repository into a new directory.
# The name of the new directory should be provided as an argument when running this script.
# After cloning the repository, the script will call 'all-the-things.sh' to run a default build of 'the-power'.
# Place this script in your local path to run it from anywhere.
#
# Usage: ./script.sh <new-directory-name>

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

# Change to the new directory
cd ~/the-power/$1 || { echo "Error: Failed to change directory."; exit 1; }

# Create a Python virtual environment
if ! python3 -m venv myenv; then
    echo "Error: Failed to create virtual environment."
    exit 1
fi

# Activate the virtual environment
source myenv/bin/activate || { echo "Error: Failed to activate the virtual environment."; exit 1; }

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
