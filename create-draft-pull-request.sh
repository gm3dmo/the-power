.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/pulls?apiVersion=2022-11-28#create-a-pull-request
# POST /repos/{owner}/{repo}/pulls


timestamp=$(date +%s)
title="Amazing new feature PR: $timestamp"

lorem_file="test-data/lorem-pull-request.md"
lorem_text=$(cat $lorem_file)


json_file="create-pull-request.json"

jq -n \
  --arg title "$title (started as draft PR)" \
  --arg body "${lorem_text}" \
  --arg head "${branch_name}" \
  --arg base "${base_branch}" \
  --arg draft "true"  \
  '{
    title: $title,
    body: $body,
    head: $head,
    base: $base,
    draft: $draft | test("true")
  }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls" --data @${json_file}

