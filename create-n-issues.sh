. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-an-issue
# POST /repos/:owner/:repo/issues

raw_text="/README.md @${org}/${team_slug}" 
base64_string=$(echo ${raw_text} | base64)
content=${base64_string}

count_of_issues_to_create=${1:-10}

for i in seq ${count_of_issues_to_create}
do
    sleep 2
    timestamp=$(date +%s)
    json_file=tmp/create-repo-issue.json
    rm -f ${json_file}
    jq -n \
            --arg title "Found a bug ($timestamp)  ${i}" \
            --arg body "test commit message" \
            --arg assignees "${team}" \
            --arg milestone 1 \
            --arg lb "bug" \
    	'{"title": $title, "body": $body }'  > ${json_file}
    
    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json_file" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues --data @${json_file}

    rm -f ${json_file}
done
