.  .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#add-a-repository-collaborator
# PUT /repos/{owner}/{repo}/collaborators/{username}

# limits: https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository


username=${1:-lisa}
permission=${2:-push}

JSON_TEMPLATE='{"permission":"%s"}'
JSON_DATA=$(printf "$JSON_TEMPLATE" "$permission")

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
               ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/collaborators/${username} -d ${JSON_DATA}

