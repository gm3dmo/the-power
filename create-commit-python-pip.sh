. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-the-dependency-graph#supported-package-ecosystems

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

shopt -s -o nounset

source_file="test-data/python/pip/requirements.txt_"
base64_source_file=$(base64 ${source_file})
content=${base64_source_file}

filename_in_repo="requirements.txt"
comment="Adding a ${filename_in_repo}"

json_file=tmp/create-commit-python-pip.json

jq -n \
                --arg nm "${default_committer}" \
                --arg ms  "Adding a ${filename_in_repo} file for ${comment}" \
                --arg em  "${USER}+${default_committer}@${mail_domain}" \
                --arg ct  "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
