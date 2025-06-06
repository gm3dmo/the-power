.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-for-the-authenticated-user
# POST /user/repos


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


if [[ ${default_repo_visibility} == "private" ]]; then
    p="true"
else
    p="false"
fi

json_file=tmp/create-a-repository-for-the-authenticated-user.json
jq -n \
           --arg name "${repo}" \
           --arg private $p \
           --arg visibility ${default_repo_visibility} \
           '{
             name : $name,
             private: $private | test("true"),
             visibility: $visibility
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/repos" --data @${json_file}

