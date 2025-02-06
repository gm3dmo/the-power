.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-scanning#upload-an-analysis-as-sarif-data
# POST /repos/{owner}/{repo}/code-scanning/sarifs

# Data sourced from:
# https://lgtm.com/projects/g/angular/angular/alerts/?mode=list

name=angular_angular__2022-02-10_17_36_10__export
sarif_file=test-data/codeql/sarif/${name}.sarif
sarif_b64_file=test-data/${name}.b64
gzip -c ${sarif_file} | ./base64encode.py  > ${sarif_b64_file}
file ${sarif_b64_file}

sarif_b64_string=$(cat ${sarif_b64_file})
tool_name="the-power-sarif-upload-test"

json_file=tmp/upload-an-analysis-as-sarif-data.json


commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${base_branch}| jq -r '.object.sha')

ref="refs/heads/main"

jq -n \
           --arg commit_sha "${commit_sha}" \
           --arg ref "${ref}" \
           --arg sarif ${sarif_b64_string} \
           --arg tool_name ${tool_name} \
           '{
             commit_sha : $commit_sha,
             ref : $ref,
             sarif : $sarif
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/code-scanning/sarifs"  --data @${json_file}

