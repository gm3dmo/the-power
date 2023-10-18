.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/search?apiVersion=2022-11-28#search-repositories
# https://api.github.com/search/repositories?q=Q

# WORKS ON A MAC
default_start_date="$(date -v -7d +'%Y-%m-%d')"

# Pass query as an argument, otherwise list all repos with commits in the last seven days
if [ -z "$1" ]
  then
    query="pushed:>${default_start_date}"
  else
    query="$1"
fi

per_page=100

report_file=report.csv
truncate -s0 report.csv

# https://docs.github.com/en/rest/guides/using-pagination-in-the-rest-api?apiVersion=2022-11-28

curl_custom_flags="--write-out %output{headers.json}%{header_json} --silent" 

curl ${curl_custom_flags} \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     "${GITHUB_API_BASE_URL}/search/repositories?q=${query}&per_page=${per_page}" | jq -r '.items | .[] | [.id, .pushed_at, .full_name ] | @csv' >> ${report_file}

while true; do
    link_header=$(cat headers.json | jq -r  '.link | .[]' 2>/dev/null)
    if [ -z "$link_header" ]; then
        echo "Link header is empty or null. There are no more pages to pull from GitHub. Exiting." >&2
        break
    fi
    last_link=$(echo "$link_header" | grep -o -E '<[^>]+>; rel="last"' | sed -e 's/.*rel="//' -e 's/".*//')
    next_url=$(echo "$link_header" | grep -o -E '<[^>]+>; rel="next"' | sed -e 's/<//' -e 's/>.*//')
    
    echo "Link Header: ($link_header)" >&2
    echo "next_url: ($next_url)" >&2

    set -x
    curl ${curl_custom_flags} \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         "${next_url}" | jq -r '.items | .[] | [.id, .pushed_at, .full_name ] | @csv' >> ${report_file}
    set +x
    echo 
done

