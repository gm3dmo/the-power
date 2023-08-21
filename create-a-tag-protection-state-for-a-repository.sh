.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/tags#create-a-tag-protection-state-for-a-repository
# POST /repos/{owner}/{repo}/tags/protection

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

tag_protection_pattern="v1.*"

json_file=tmp/skeleton.json

jq -n \
           --arg pattern "${tag_protection_pattern}" \
           '{
             pattern : $pattern,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/tags/protection --data @${json_file}
