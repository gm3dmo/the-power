. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-a-github-pages-site
# POST /repos/:owner/:repo/pages


json_file=tmp/create-pages.json
rm -f ${json_file}

jq -n \
        --arg branch "${base_branch}" \
        --arg path "/docs" \
	'{"source": {"branch": $branch, "path": $path }}'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.switcheroo-preview+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pages --data @${json_file}

rm -f ${json_file}
