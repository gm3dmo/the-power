.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#reprioritize-sub-issue
# PATCH /repos/{owner}/{repo}/issues/{issue_number}/sub_issues/priority


# If the script is passed an argument $1 use that as the issue_number
if [ -z "$1" ]
  then
    echo "Error: issue_number is required as first argument"
    exit 1
  else
    issue_number=$1
fi

# If the script is passed an argument $2 use that as the sub_issue_id
if [ -z "$2" ]
  then
    echo "Error: sub_issue_id is required as second argument"
    exit 1
  else
    sub_issue_id=$2
fi

# If the script is passed an argument $3 use that as the after_id
if [ -z "$3" ]
  then
    echo "Error: after_id or before_id is required as third argument"
    exit 1
  else
    after_id=$3
fi


json_payload=$(cat <<EOF
{
  "sub_issue_id": ${sub_issue_id},
  "after_id": ${after_id}
}
EOF
)

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/issues/${issue_number}/sub_issues/priority" \
     -d "${json_payload}"
