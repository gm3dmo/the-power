.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/contents?apiVersion=2022-11-28#create-or-update-file-contents
# PUT /repos/{owner}/{repo}/contents/{path}

# If the script is passed an argument $1 use that as the branch
if [ -z "$1" ]
  then
    branch=${base_branch}
  else
    branch=${1}
fi

# If the script is passed an argument $1 use that as the name
if [ -z "$2" ]
  then
    repo=${repo}
  else
    repo=$2
fi

json_file=tmp/create-or-update-file-contents.json

content="dGVzdAo="

filename="docs/README.md"

#Required if you are updating a file. The blob SHA of the file being replaced.
blob_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename}| jq -r '.sha')

path="${filename}"

timestamp=$(date +%s)

jq -n \
                --arg message "test commit message ${timestamp}" \
                --arg content "${content}" \
                --arg branch "${branch}" \
                --arg sha "${blob_sha}" \
                '{message: $message, branch: $branch, content: $content, sha: $sha }'  > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${path}" --data @${json_file}

