.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/reactions#create-reaction-for-an-issue-comment
# POST /repos/{owner}/{repo}/issues/comments/{comment_id}/reactions



# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    comment_id=$(./list-repository-issue-comments.sh | jq '[.[].id] | max')
  else
    comment_id=$1
fi

echo $comment_id

set -x

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/comments/${comment_id}/reactions --data '{"content":"rocket"}'
