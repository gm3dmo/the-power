.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/projects#create-a-repository-project
# POST /repos/:owner/:repo/projects

A=$1
wanted=${A:=nopreview}

json_file=tmp/project-details.json
rm -f ${json_file}

DATA=$(jq -n \
                  --arg nm "${repo}-project" \
                  --arg bd "${repo} things to manage." \
                  '{name : $nm, body: $bd}') 

echo ${DATA} > ${json_file}

if [ ${wanted} == "preview" ]; then
    >&2 echo header in place this will succeed.
    curl ${curl_custom_flags} \
         -X POST \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Accept: application/vnd.github.inertia-preview+json"  \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/projects --data @${json_file}
else
    >&2 echo no header in place this will fail. run with 'preview' argument.
    curl ${curl_custom_flags} \
         -X POST \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/projects --data @${json_file}
fi

rm -f ${json_file}
