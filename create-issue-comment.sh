.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-an-issue-comment
# POST /repos/{owner}/{repo}/issues/{issue_number}/comments

issue_id=${1:-1}

json_file="tmp/issue-comment.json"

timestamp=$(date +%s)
lorem_file="test-data/lorem-issue-comment.md"
lorem_text=$(cat $lorem_file)
# timestamp is in `lorem_append` to prevent the "similar comments" thing from activating.
lorem_append="<br><br><br>The @${org}/${team_slug} will be interested in this. ${timestamp}"


    jq -n \
      --arg body "${lorem_text}${lorem_append}" \
           '{
             body: $body
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.full+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_id}/comments -d @${json_file}
