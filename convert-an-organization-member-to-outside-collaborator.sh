. .gh-api-examples.conf

# https://docs.github.com/en/rest/orgs/outside-collaborators#convert-an-organization-member-to-outside-collaborator
# PUT /orgs/{org}/outside_collaborators/{username}
      /orgs/     /outside_collaborators/roger-de-courcey

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    username=${default_committer}
  else
    username=$1
fi

json_file=tmp/convert-an-organization-member-to-outside-collaborator.json

jq -n \
           --arg name "${repo}" \
           '{
            async : true,
           }' > ${json_file}

cat $json_file | jq -r

set -x

+ curl -v -H 'Accept: application/vnd.github.v3+json' -H 'Authorization: Bearer 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' 

--data @tmp/convert-an-organization-member-to-outside-collaborator.json

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/outside_collaborators/${username} --data @${json_file}
