.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/markdown/markdown?apiVersion=2022-11-28#render-a-markdown-document
# POST /markdown


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    mode=markdown
  else
    mode=$1
fi

echo "mode: ${mode}" >&2
context="${owner}/${repo}"

json_file=tmp/render-a-markdown-document.json
jq -n \
           --arg text "## Title\nhello **world** In the issue #1 and the PR #2" \
           --arg mode "$mode" \
           --arg context "$context" \
           '{
             text: $text,
             mode: $mode,
             context: $context,
            }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/markdown?mode=${mode}"  --data @${json_file}

