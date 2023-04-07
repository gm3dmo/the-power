.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

for file in $(ls tmp/wp_*.json)
do
    fn=${file%.*}
    fn_json=${fn}.json
    fn_minus=${fn:4}
    fn_plus_ext=${fn_minus}.${file_extension}
    if [ -f ${fn_json} ]; then
        echo $fn_plus_ext
        curl ${curl_custom_flags} \
            -X PUT \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: Bearer ${GITHUB_TOKEN}" \
               ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/src/${fn_plus_ext} --data @${fn_json}
    fi
done
