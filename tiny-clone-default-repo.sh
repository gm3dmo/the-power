.  ./.gh-api-examples.conf

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
rm -rf testrepo
git clone https://ghe-admin:${GITHUB_TOKEN}@${hostname}/${org}/${repo}.git
cat testrepo/docs/README.md
rm -rf testrepo


