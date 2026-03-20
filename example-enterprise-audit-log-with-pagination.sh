#!/bin/bash
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/enterprise-admin/audit-log
# GET /enterprises/{enterprise}/audit-log

actor=$1
per_page=10
include="all"
response_file="response.json"

curl_custom_flags="--write-out %output{headers.json}%{header_json} --silent"

# Start with an empty JSON array
echo '[]' > "${response_file}"

page_url="${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?phrase=actor:${actor}&per_page=${per_page}&include=${include}"

while true; do
    echo "Fetching: ${page_url}" >&2

    page_data=$(curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${page_url}")

    # Append this page's results into the response file
    jq -s '.[0] + .[1]' "${response_file}" <(echo "${page_data}") > "${response_file}.tmp" \
        && mv "${response_file}.tmp" "${response_file}"

    # Extract the after cursor from the Link header's next URL
    link_header=$(jq -r '.link | .[]' headers.json 2>/dev/null)
    if [ -z "${link_header}" ]; then
        echo "No more pages. Done." >&2
        break
    fi

    next_url=$(echo "${link_header}" | grep -o -E '<[^>]+>; rel="next"' | sed -e 's/<//' -e 's/>.*//')
    if [ -z "${next_url}" ]; then
        echo "No next link found. Done." >&2
        break
    fi

    # Extract the after cursor from the next URL
    after=$(echo "${next_url}" | grep -o -E 'after=[^&]+' | sed 's/after=//')
    if [ -z "${after}" ]; then
        echo "No after cursor found in next URL. Done." >&2
        break
    fi

    page_url="${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?phrase=actor:${actor}&per_page=${per_page}&include=${include}&after=${after}"
done

echo "Results saved to ${response_file}" >&2
jq length "${response_file}"


jq -r '.[] | [.action, .actor, (.["@timestamp"] / 1000 | strftime("%Y-%m-%dT%H:%M:%SZ"))] | @csv' ${response_file}
