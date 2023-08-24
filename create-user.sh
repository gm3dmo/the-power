.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/users?apiVersion=2022-11-28#create-a-user
# POST /admin/users

if [ -z "$1" ]
  then
    new_user=${default_committer}
  else
    new_user=$1
fi


DATA=$( jq -n \
               --arg login "${new_user}" \
               --arg email "${USER}+${new_user}@${mail_domain}" \
                 '{login : $login, email: $email}' )

echo $DATA > tmp/${new_user}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/users --data @tmp/${new_user}

rm -f tmp/${new_user}
