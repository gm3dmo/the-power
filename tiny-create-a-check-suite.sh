.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/suites?apiVersion=2022-11-28#create-a-check-suite
# POST /repos/{owner}/{repo}/check-suites
#
# This script probably needs to run also:
# update-repository-preferences-for-check-suites.sh


if [ -z "$1" ]
  then
    head_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch_name}| jq -r '.object.sha')
  else
    head_sha=$1
fi


json_file=tmp/create-a-check-suite.json
jq -n \
           --arg head_sha "${head_sha}" \
           '{
             head_sha: $head_sha
           }' > ${json_file}


cat $json_file | jq -r

# Only GitHub Apps may use the checks api so we override the token
GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/check-suites" --data @${json_file}

