#!/bin/sh

set -e

usage() {
    echo "Usage: build-mobile.sh <enterprise host url> <personal access token>"
    exit 1
}


# fail when no parameters are supplied
if [ ! $# -eq 2 ]
  then
    usage
fi

# process arguments supplied
printf "Server URL: $1"
printf "Auth token: $2"
printf "Configuring The Power"

python3 configure.py -n $1 -t $2 -o bigandroidenergies -r and1

printf "Generating test data"

./build-all.sh