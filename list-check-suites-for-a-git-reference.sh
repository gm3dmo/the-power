.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/checks/suites#list-check-suites-for-a-git-reference
# GET /repos/{owner}/{repo}/commits/{ref}/check-suites

ref=$1

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${ref}/check-suites


