. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/checks#create-a-check-run
# POST /repos/{owner}/{repo}/check-runs
 
if [ -z "$1" ]
  then
     head_sha=$(curl --silent -H "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch}| jq -r '.object.sha')
  else
     head_sha=$1
fi

GITHUB_APP_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

json_file=tmp/create-check-run.json

jq -n \
       --arg name "code-coverage" \
       --arg head_sha "${head_sha}" \
       --arg status "queued" \
       '{ head_sha: $head_sha, status: $status, name: $name, "output":{"title":"Mighty Readme report","summary":"testing a failure","text":"This should annotate the first line of a commit ","annotations":[{"path":".gitattributes","annotation_level":"failure","title":"Spell Checker","message":"Check your spelling for 'banaas'.","raw_details":"Do you mean 'bananas' or 'banana'?","start_line":1,"end_line":1}]}}' > ${json_file}
cat ${json_file} | jq -r

curl ${curl_custom_flags} \
     -X POST \
     -H "Authorization: token ${GITHUB_APP_TOKEN}"  \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.antiope-preview+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-runs \
        --data @${json_file}
