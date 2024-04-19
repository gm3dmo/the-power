.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi
#
if [ -z "$2" ]
  then
    filename_in_repo="syslog.ipynb"
  else
    filename_in_repo=$2
fi

# This doesn't work when the base64'ed string is overly large
# e.g. with my ipynb file. Perhaps the base64 can be slurped
# into the json field from a file?
# I found this:
# https://stackoverflow.com/questions/61154881/how-to-send-arguments-with-slurpfile-and-jq

template_file=$(printf "${filename_in_repo}%s" "_")
base64_string=$(./base64encode.py ${template_file})
comment="Adding ${filename_in_repo}"
json_file="tmp/create-commit.json"

rm ${json_file}

content="woo"


jq -n \
                --arg nm "${default_committer}" \
                --arg ms  "${comment}" \
                --arg em  "${USER}+${default_committer}@${mail_domain}" \
                --arg ct  "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
