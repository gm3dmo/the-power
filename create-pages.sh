.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pages/pages?apiVersion=2022-11-28#create-a-github-pages-site
# GET /repos/{owner}/{repo}/pages

# ui: https://docs.github.com/en/pages
# limits: https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#limits-on-use-of-github-pages


json_file=tmp/create-pages.json
jq -n \
        --arg branch "${base_branch}" \
        --arg path "/docs" \
	'{"source": {"branch": $branch, "path": $path }}' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pages" --data @${json_file}

