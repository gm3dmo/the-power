.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/billing/budgets?apiVersion=2026-03-10#get-all-budgets-for-an-organization
# GET /organizations/{org}/settings/billing/budgets

org=${1:-${org}}
page=${2:-1}
per_page=${3:-10}
scope=${4:-}
user=${5:-}

url="${GITHUB_API_BASE_URL}/organizations/${org}/settings/billing/budgets?page=${page}&per_page=${per_page}"

if [ -n "${scope}" ]
  then
    url="${url}&scope=${scope}"
fi

if [ -n "${user}" ]
  then
    url="${url}&user=${user}"
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${url}"
