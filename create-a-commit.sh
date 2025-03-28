.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/commits?apiVersion=2022-11-28#create-a-commit 
# POST /repos/{owner}/{repo}/git/commits


if [ -z "$1" ]
  then
    tree_sha=$tree_sha
  else
    tree_sha=$1
fi


last_commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${base_branch} | jq -r '.commit.sha')

json_file=tmp/create-commit.json
jq -n \
                --arg name     "${default_committer}" \
                --arg message  "test commit message ${RANDOM}" \
                --arg email    "${USER}+${default_committer}@${mail_domain}" \
                --arg date     "$(date +%Y-%m-%dT%H:%M:%SZ)" \
                --arg tree_sha "${tree_sha}" \
                --arg last_commit_sha "${last_commit_sha}" \
                      '{message: $message, "author":{ "name" : $name, "email": $email , "date": $date}, "parents": [ $last_commit_sha ], "tree": $tree_sha   }'  > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/commits" --data @${json_file}

