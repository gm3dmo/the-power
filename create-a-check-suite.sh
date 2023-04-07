.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/checks/suites#create-a-check-suite
# POST /repos/{owner}/{repo}/check-suites

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


json_file=tmp/create-a-check-suite.json

jq -n \
           --arg name "${repo}" \
           '{
             name : $name,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/check-suites --data @${json_file}


