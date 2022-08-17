. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-an-issue
# POST /repos/:owner/:repo/issues


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

raw_text="/README.md @${org}/${team_slug}" 
base64_string=$(echo ${raw_text} | base64)
content=${base64_string}

lorem_text_file=test-data/lorem-issue.md
lorem_text=$(cat $lorem_text_file)

timestamp=$(date +%s)

json_file=tmp/create-repo-issue.json
rm -f ${json_file}

jq -n \
        --arg title "Found a bug ($timestamp) " \
        --arg body "${lorem_text}" \
        --arg assignees "${default_committer}" \
        --arg milestone 1 \
        --arg labels "bug" \
	'{"title": $title, "body": $body, "assignees": [ $assignees ], "labels": [ $labels ] }'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues --data @${json_file}

rm -f ${json_file}
