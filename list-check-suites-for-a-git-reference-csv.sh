.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/suites?apiVersion=2022-11-28#list-check-suites-for-a-git-reference
# GET /repos/{owner}/{repo}/commits/{ref}/check-suites


if [ -z "$1" ]
  then
     ref=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch_name}| jq -r '.object.sha')
  else
     ref=$1
fi

response_file=tmp/list-check-suites-for-a-git-reference.json

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${ref}/check-suites" > ${response_file}

jq -r '
  ["Cnt","ID","Head Branch","Head SHA","Status","PR","App Name","Created At","Updated At"],
  ( .check_suites | to_entries[] |
    [ ( .key | tonumber + 1 | tostring ),
      ( .value.id | tostring ),
      .value.head_branch,
      .value.head_sha,
      .value.status,
      ( .value.pull_requests | map(.number | tostring) | join(";") ),
      .value.app.name,
      .value.created_at,
      .value.updated_at ] )
  | @csv' tmp/response.json | csvlook --no-inference
