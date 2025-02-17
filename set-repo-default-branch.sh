.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#update-a-repository
# PATCH /repos/{owner}/{repo}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    new_default_branch=${new_branch}
  else
    new_default_branch=$1
fi


json_file=tmp/update-a-repository-set-default-branch.json
jq -n \
       --arg new_default_branch ${new_default_branch} \
         '{
            default_branch: $new_default_branch,
          }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file}

