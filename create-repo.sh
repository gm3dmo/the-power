.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-an-organization-repository
# POST /orgs/:org/repos


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


if [ ${default_repo_visibility} = "private" ]
   then
    p="true"
   else
    p="false"
fi

json_file=tmp/repo-details.json
rm -f ${json_file}

jq -n \
           --arg name "${repo}" \
           --arg private $p \
           --arg visibility ${default_repo_visibility} \
           --arg delete_branch_on_merge ${delete_branch_on_merge} \
           '{
             name : $name,
             private: $private | test("true"),
             visibility: $visibility,
             delete_branch_on_merge: $delete_branch_on_merge | test("true")
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.nebula-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/repos --data @${json_file}

