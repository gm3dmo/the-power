.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/refs?apiVersion=2022-11-28#get-a-reference
# GET /repos/{owner}/{repo}/git/ref/{ref}


if [ -z "$1" ]
  then
    ref="heads/$base_branch"
  else
    ref="heads/$1"
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/${ref}"

