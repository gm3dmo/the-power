.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#list-organization-repositories
# GET /orgs/{org}/repos

# Demonstrates paging

page=${1:-1}
per_page=100
type=all

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/repos?page=${page}&per_page=${per_page}&type=${type}"

