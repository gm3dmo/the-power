.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# https://getcomposer.org/doc/01-basic-usage.md

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

shopt -s -o nounset


source_file="test-data/php/composer/composer.json_"
base64_source_file=$(./base64encode.py ${source_file})
content=${base64_source_file}

filename_in_repo="composer.json"
comment="Adding ${filename_in_repo}"

json_file=tmp/create-commit-rust-cargo-lock.json

jq -n \
                --arg nm "${default_committer}" \
                --arg ms  "Adding a ${filename_in_repo} file for ${comment}" \
                --arg em  "${USER}+${default_committer}@${mail_domain}" \
                --arg ct  "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
