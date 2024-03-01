.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/dependency-graph/dependency-submission?apiVersion=2022-11-28#create-a-snapshot-of-dependencies-for-a-repository
# POST /repos/{owner}/{repo}/dependency-graph/snapshots




json_file=tmp/create-a-snapshot-of-dependencies-for-a-repository.json

jq -n \
           --arg version 0 \
           '{"version":0,"sha":"ce587453ced02b1526dfb4cb910479d431683101","ref":"refs/heads/main","job":{"correlator":"yourworkflowname_youractionname","id":"yourrunid"},"detector":{"name":"octo-detector","version":"0.0.1","url":"https://github.com/octo-org/octo-repo"},"scanned":"2022-06-14T20:25:00Z","manifests":{"package-lock.json":{"name":"package-lock.json","file":{"source_location":"src/package-lock.json"},"resolved":{"@actions/core":{"package_url":"pkg:/npm/%40actions/core@1.1.9","dependencies":["@actions/http-client"]},"@actions/http-client":{"package_url":"pkg:/npm/%40actions/http-client@1.0.7","dependencies":["tunnel"]},"tunnel":{"package_url":"pkg:/npm/tunnel@0.0.6"}}}}} ' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/dependency-graph/snapshots"  --data @${json_file}
