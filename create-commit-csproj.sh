.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

base64_string=$(./base64encode.py dotnet.csproj_)
content=${base64_string}
filename_in_repo=dotnet.csproj
comment=".net project file like a pom.xml or requirements.txt. Used to trigger dependabot."

json_file=tmp/create-commit-csproj.json

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
