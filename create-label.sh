.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-a-label
# POST /repos/:owner/:repo/labels

json_file="test-data/label.json"
color="ff00ff"

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    label_name="testlabel1"
  else
    label_name=$1
fi

jq -n \
           --arg name "${label_name}" \
           --arg description "a test label" \
           --arg color "f29513" \
           '{
             name: $name,
             description: $description,
             color: $color
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/labels --data @${json_file}
