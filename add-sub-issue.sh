.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#add-sub-issue
# POST /repos/{owner}/{repo}/issues/{issue_number}/sub_issues


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

raw_text="/README.md @${org}/${team_slug}" 
base64_string=$(echo ${raw_text} | ./base64encode.py)
content=${base64_string}

lorem_text_file=test-data/lorem-sub-issue.md
lorem_text=$(cat $lorem_text_file)
lorem_append="<br><br><br>The @${org}/${team_slug} will be interested in this. ${timestamp}"

timestamp=$(date +%s)

json_file=tmp/add-sub-issue.json

jq -n \
        --arg title "Incorporate cloud computing sensibility into the fix ($timestamp)" \
        --arg body "${lorem_text}${lorem_append}" \
        --arg assignees "${default_issue_assignee}" \
        --arg milestone 1 \
        --argjson labels '["bug", "documentation"]' \
	'{"title": $title, "body": $body, "assignees": [ $assignees ], "labels":  $labels  }' > ${json_file}

# Create the issue
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues" --data @${json_file} > tmp/sub-issue-id.txt

sub_issue_id=$(jq -r '.id' tmp/sub-issue-id.txt)
sub_issue_json="{\"sub_issue_id\": $sub_issue_id}"
# Now add it as a sub-issue to the parent issue
echo "Adding sub-issue ${sub_issue_id} to issue 1"
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/1/sub_issues" --data "${sub_issue_json}"
