.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/tags?apiVersion=2022-11-28
# POST /repos/{owner}/{repo}/git/tags


sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${base_branch} | jq -r '.object.sha')
date_of_tag=$(date +'%Y-%m-%dT%H:%M:%S-00:00')
tag=$(date +%s)


json_file=tmp/create-tag.json
jq -n \
                --arg tag "tag_${tag}" \
                --arg message "this is tag (${tag})" \
                --arg object "${sha}" \
                --arg _type "commit" \
                --arg name "${default_committer}" \
                --arg email "${USER}+${default_committer}@${mail_domain}" \
                --arg date "${date_of_tag}" \
                '{tag : $tag, message: $message, object : $object, type: $_type,
             tagger: {name: $name, email: $email, date: $date} }'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/tags" --data @${json_file}
