.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-commits
# GET /repos/{owner}/{repo}/commits


# ./list-commits-on-repo.sh  | jq -r '.[] | [ .sha, .commit.author.date, .commit.message ] | @csv'

sha=${1:base_branch}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits?sha=${sha}"
