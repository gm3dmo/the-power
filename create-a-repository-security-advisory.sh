.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/security-advisories/repository-advisories?apiVersion=2026-03-10#create-a-repository-security-advisory
# POST /repos/{owner}/{repo}/security-advisories

repo=${1:-${repo}}
timestamp=$(date +%s)
json_file=tmp/create-a-repository-security-advisory.json

jq -n \
     --arg summary "Security advisory for ${repo} ${timestamp}" \
     --arg description "A test repository security advisory created by the-power." \
     --arg package_name "${repo}" \
     '{
       summary: $summary,
       description: $description,
       severity: "high",
       vulnerabilities: [
         {
           package: {
             ecosystem: "other",
             name: $package_name
           },
           vulnerable_version_range: "< 1.0.0",
           patched_versions: "1.0.0"
         }
       ],
       cwe_ids: ["CWE-20"]
     }' > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/security-advisories" --data @${json_file}
