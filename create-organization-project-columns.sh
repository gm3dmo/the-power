.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/projects#create-a-project-column
# POST /projects/:project_id/columns

shopt -s -o nounset

A=$1
wanted=${A:=nopreview}

json_file=tmp/projectcolumns.json
rm -f ${json_file}

all_column_names=(To\ do In\ progress Done)

# Get the project id:
p=$(./list-organization-projects.sh 2>/dev/null | jq '.[] | .id' )
# Gnarly hack that just gets us the last number:
for item in $p
do
 :
done
echo $item
project_id=${item}

for ((i = 0; i < ${#all_column_names[@]}; i++))
do
    jq -n \
            --arg name "${all_column_names[$i]}" \
            '{ name : $name }' > ${json_file}

    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Accept: application/vnd.github.inertia-preview+json"  \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          ${GITHUB_API_BASE_URL}/projects/${project_id}/columns --data @${json_file}
    cat ${json_file}
done
rm -f ${json_file}
