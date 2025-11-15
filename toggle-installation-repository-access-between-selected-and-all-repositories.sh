.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/organization-installations?apiVersion=2022-11-28#toggle-installation-repository-access-between-selected-and-all-repositories
# PATCH /enterprises/{enterprise}/apps/organizations/{org}/installations/{installation_id}/repositories


if [ -z "$1" ]
  then
    installation_id=${ent_app_org_installation_id}
  else
    installation_id=$1
fi

repository_selection="selected"

json_file=tmp/toggle-installation-repository-access-between-selected-and-all-repositories.json
jq -n \
           --arg repo "${repo}" \
           --arg repository_selection "${repository_selection}" \
           '{
             repository_selection : $repository_selection, "repositories":  [ $repo ]
           }' > ${json_file}


GITHUB_TOKEN=$(./ent-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/apps/organizations/${org}/installations/${installation_id}/repositories"  --data @${json_file}

