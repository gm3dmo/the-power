.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#remove-app-access-restrictions
# DELETE /repos/{owner}/{repo}/branches/{branch}/protection/restrictions/apps

branch=${protected_branch_name}

if [ -z "$1" ]
  then
    app_slug="${app_slug}"
  else
    app_slug=$1
fi

json_file=tmp/remove-app-access-restrictions.json
jq -n \
       --arg app_slug "${app_slug}" \
       '{
         apps: [ $app_slug ]
       }' > ${json_file}

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/restrictions/apps" --data @${json_file}
