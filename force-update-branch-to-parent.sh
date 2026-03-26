.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/git/refs?apiVersion=2022-11-28#update-a-reference
# PATCH /repos/{owner}/{repo}/git/refs/{ref}
#
# Force-updates a branch to its parent commit, destroying the latest commit.
# This demonstrates a destructive force-push that rewrites branch history.

if [ -z "$1" ]
  then
    branch=${branch_name}
  else
    branch=$1
fi

# Get the current tip commit SHA of the branch
tip_sha=$(curl ${curl_custom_flags} --silent \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}" | jq -r '.commit.sha')

# Get the parent commit SHA (one commit back)
parent_sha=$(curl ${curl_custom_flags} --silent \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/commits/${tip_sha}" | jq -r '.parents[0].sha')

json_file=tmp/force-update-branch-to-parent.json

jq -n \
       --arg sha "${parent_sha}" \
              '{ sha: $sha,
                 force: true
                }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch}" --data @${json_file}
