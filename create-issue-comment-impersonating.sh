.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-an-issue-comment
# POST /repos/{owner}/{repo}/issues/{issue_number}/comments

issue_id=${1:-1}
user_to_impersonate=${2:-$default_committer}

IMPERSONATION_TOKEN=$(bash create-impersonation-oauth-token.sh ${user_to_impersonate}| jq -r '.token')
GITHUB_TOKEN=${IMPERSONATION_TOKEN}

json_file="tmp/issue-comment.json"

lorem_file="lorem-issue-comment.md"
lorem_text=$(cat $lorem_file)
random_number=${RANDOM}


jq -n \
   --arg body "${lorem_text} ${random_number}" \
         '{
           body: $body
          }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.full+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_id}/comments -d @${json_file}
