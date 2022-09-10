. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams#creating-mermaid-diagrams

if [ -z "$1" ]
  then
    diagram_types="flowchart sequence-diagram class-diagram state-diagram gantt-chart pie-chart er-diagram user-journey git-graph geojson"
  else
    diagram_types=$1
fi

if [ -z "$2" ]
  then
    repo=$repo
  else
    repo=$2
fi


for diagram_type in ${diagram_types}

do
    if [ -z "$2" ]
      then
        filename_in_repo="${diagram_type}.md"
      else
        filename_in_repo=$2
    fi
    
    # This doesn't work when the base64'ed string is overly large
    # e.g. with my ipynb file. Perhaps the base64 can be slurped
    # into the json field from a file?
    # I found this:
    # https://stackoverflow.com/questions/61154881/how-to-send-arguments-with-slurpfile-and-jq
    
    template_file=$(printf "test-data/mermaid/${filename_in_repo}%s" "_")
    base64_string=$(base64 ${template_file})
    comment="Adding ${filename_in_repo}"
    json_file="tmp/create-commit.json"
    
    rm ${json_file}
    
    content=$base64_string
    
    jq -n \
                    --arg nm "${default_committer}" \
                    --arg ms  "${comment}" \
                    --arg em  "${USER}+${default_committer}@${mail_domain}" \
                    --arg ct  "${content}" \
                    '{message: $ms, "committer":{ "name" : $nm, "email": $em }, content: $ct }'  > ${json_file}
    
    cat $json_file | jq -r
    
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: token ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/mermaid-diagrams/${filename_in_repo} --data @${json_file}

 done
