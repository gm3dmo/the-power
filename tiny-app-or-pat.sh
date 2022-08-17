. .gh-api-examples.conf

if [ -z "$1" ]
  then
      GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
      echo "+++++++++++++++++++++++++++++++++++++++++++++" >&2
      echo "    Using App ${GITHUB_TOKEN}" >&2
      echo "+++++++++++++++++++++++++++++++++++++++++++++" >&2
  else
      echo "=============================================" >&2
      echo using PAT ${GITHUB_TOKEN} >&2
      echo "=============================================" >&2
fi

echo

echo press enter when ready

read x

# GET the list of repos in the organization:

set -x
curl -v -H "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/orgs/${org}/repos

