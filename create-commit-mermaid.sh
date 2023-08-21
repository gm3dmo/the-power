.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams#creating-mermaid-diagrams
#

# Generate the json commit files for each diagram type:
python3 mermaid-json-commit-generator.py

diagram_types="flowchart sequence-diagram class-diagram state-diagram gantt-chart er-diagram user-journey git-graph geojson c4"

for diagram_type in ${diagram_types}
do
  filename_in_repo="${diagram_type}.md"
  json_file=tmp/${diagram_type}.json
  curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/mermaid-diagrams/${filename_in_repo} --data @${json_file}
 done

