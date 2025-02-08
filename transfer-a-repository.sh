.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#transfer-a-repository
# POST /repos/{owner}/{repo}/transfer


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# If the script is passed an argument $2 use that as the new owner
if [ -z "$2" ]
  then
    # you need to put the `default_owner` variable  in the config file to use it.
    new_owner=${default_owner}
  else
    new_owner=${2}
fi

json_file=tmp/transfer-a-repository.json

    jq -n \
           --arg new_owner "${new_owner}" \
           '{
             new_owner: $new_owner
           }' > ${json_file}


curl -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/transfer" --data @${json_file}

