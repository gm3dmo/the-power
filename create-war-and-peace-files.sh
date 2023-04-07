.  ./.gh-api-examples.conf

### This example adds the chapters of the war and peace book as commits.

python3 war-and-peace-json.py

ext=py

for file in $(ls tmp/wp_*.json)
do
    fn=${file:4}
    fn=${fn#*}
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
             ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/docs/${fn}.${ext} --data @tmp/${fn}
    sleep 1
done
