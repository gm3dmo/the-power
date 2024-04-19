.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-an-issue
# POST /repos/:owner/:repo/issues


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

raw_text="/README.md @${org}/${team_slug}" 
base64_string=$(echo ${raw_text} | ./base64encode.py)
content=${base64_string}

lorem_text_file=test-data/lorem-issue.md
lorem_text=$(cat $lorem_text_file)
lorem_append="<br><br><br>The @${org}/${team_slug} will be interested in this. ${timestamp}"

timestamp=$(date +%s)

json_file=tmp/create-repo-issue.json
rm -f ${json_file}

jq -n \
        --arg title "Security vulnerability in access control software allowing unauthorized access by dogs ($timestamp) " \
        --arg body "${lorem_text}${lorem_append}" \
        --arg assignees "${default_committer}" \
        --arg milestone 1 \
        --argjson labels '["bug", "documentation"]' \
	'{"title": $title, "body": $body, "assignees": [ $assignees ], "labels":  $labels  }'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues --data @${json_file}

rm -f ${json_file}
