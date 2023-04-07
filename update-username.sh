.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/enterprise-admin#update-the-username-for-a-user
# PATCH /admin/users/:username

old_username=${1}
new_username=${2}

json=tmp/new_username.json

rm -f ${json}

jq -n \
  --arg new_username "${new_username}" \
  '{ "login" : $new_username }'  > ${json}

cat $json

set -x
curl -v -X PATCH \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/users/${old_username} --data @$json
