.  ./.gh-api-examples.conf

# This script can be used in test cases where a endpoint
# doesn't seem to work with the GitHub App.
# The included example lists org repos. you can read in any script
# you want to test.

if [ -z "$1" ]
  then
      GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
      echo "++++++++++++++++++++ GitHub App +++++++++++++++++++++++" >&2
      echo >&2
      echo " Using App Token: ${GITHUB_TOKEN}" >&2
      echo >&2
      echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++" >&2
  else
      echo "======================== PAT ==========================" >&2
      echo >&2
      echo " Using PAT: ${GITHUB_TOKEN}" >&2
      echo >&2
      echo "=======================================================" >&2
fi

echo

printf "press enter when ready:"

read x

# GET the list of repos in the organization:

set -x
curl -v -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/repos

