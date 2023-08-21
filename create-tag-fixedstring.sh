.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-tag-object
# POST /repos/:owner/:repo/git/tags

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    tag="tag-001"
  else
    tag=$1
fi

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${base_branch} | jq -r '.object.sha')

>&2 echo ${sha}

json_file=tmp/create-tag.json

date_of_tag=$(date +'%Y-%m-%dT%H:%M:%S-00:00')


rm -f ${json_file}

jq -n \
                --arg tag "tag_${tag}" \
                --arg message "this is tag ${tag}" \
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
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/tags --data @${json_file}

rm -f ${json_file}
