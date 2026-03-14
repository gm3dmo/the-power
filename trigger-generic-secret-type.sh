
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path
#
# This script commits an RSA private key that triggers a generic secret
# type alert in GitHub secret scanning.
#
# The key is split into variables so it does not trigger a false positive
# in this repository.

# If the script is passed an argument $1 use that as the repo name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# Breaking tokens up to get past a secret scanner is a bad thing
# it will likely get you fired.

s1="-----BEGIN RSA PRIVATE KEY-----"
s2="MIICXQIBAAKBgQDAceP6BdZVBokFIqRqKHQfzuu7dCnVPfx/HNgo0KzOHBP0pbf/
LYGsKj7cuV/wabx3cP5+K0mda3LYz7T01FVXtDRPu4geJymiBdVf4liYej0kOYBH
hMf+WwxxSRmFkXYLxCfylBn1EwQML6IapaRVVi9kIp1re28m+FQq3vGgcQIDAQAB
AoGBAIEe6Vuj9v7td5neeHpR0jhVWY1Yj4joIjYXYGFiQc+4vxry5dVs7whY//yQ
1HI2P6HUSqzU1nus0E3wbvWmUetuiQqTrCisNXOfzx5MD5Go6WrxA16D7JGk2WAc
tnRNYhjA4X7qS2pp7DzEWRuU/vcgcwpzPlzKllekVDCzOmDRAkEA+rcTGI16U4Jy
nr3E2MxwiaCa0Fj/ZtUPupYR1eTSRbOsufXJtkM2rls/Hws7t/6YTKOuf8jNeWAt
7h6d+fM7swJBAMSAX8vy/+dRlMQcKF/LL3V+3okvBBMsEhXiSCCFJycFVXOJI8qF
F+0P+PVa884T9SnnHppfV0c6QFqlNUpG0UsCQQChcDFDphYWn/DedqPCViJA/MGz
VxteQ+OU6f0iFe2wJDocpD/2tOEI9Ih4nOsfVzkKYHuEnPByL5RjuCNRR2YxAkBV
eGkyst2wZgHJU14UXLKl7qspDHQ/SpoLPsOUsZYYGO/UM0CIJGAF0z68qfUGHBQ1
R7w99V5nMuUvCFEnn6oFAkA+JnjjCMy5jeOYl2yiLlzEd3jPUMyyiAe/F/pq+O9+
Ofj4YkR4rjqYiJ2BcBHn6DIYi/E7MVfmX8ky9eJNEUvA
-----END RSA PRIVATE KEY-----"

content=$(printf '%s\n%s' "${s1}" "${s2}" | python3 base64encode.py)

target_file=rsa_private_key-triggers-generic-secret-type.txt
json_file=tmp/trigger-generic-secret-type.json

# Get the sha of the existing file if it exists
existing_sha=$(curl -s \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${target_file} | jq -r '.sha // empty')

if [ -n "${existing_sha}" ]; then
    jq -n \
        --arg message  "Updating ${target_file}" \
        --arg name     "${default_committer}" \
        --arg email    "noreply+${default_committer}@example.com" \
        --arg content  "${content}" \
        --arg sha      "${existing_sha}" \
        '{
           "message": $message,
           "committer": {
             "name": $name,
             "email": $email
           },
           "content": $content,
           "sha": $sha
         }' > ${json_file}
else
    jq -n \
        --arg message  "Adding ${target_file}" \
        --arg name     "${default_committer}" \
        --arg email    "noreply+${default_committer}@example.com" \
        --arg content  "${content}" \
        '{
           "message": $message,
           "committer": {
             "name": $name,
             "email": $email
           },
           "content": $content
         }' > ${json_file}
fi

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${target_file} --data @${json_file}
