.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#update-a-label
# PATCH /repos/:owner/:repo/labels/:name

# https://www.respectability.org/2022/07/disability-pride-flag/
# https://www.urevolution.com/blogs/magazine/disability-pride-flag

bug_color=585858
documentation_color=CF7280
duplicate_color=ff0000
enhancement_color=EEDF77
gfi_color=E8E8E8
helpwanted_color=E9E9E9
invalid_color=585858
question_color=7AC1E0
wontfix_color=3AAF7D


# Because "good first issue (gfi)" and "help wanted" have spaces in the string
# we have to get a little bit creative:
# it seems like "labels" are the only place in the api where you don't use
# slug to refer to the label but urlencoding it seems to work.

for name in bug documentation duplicate enhancement gfi helpwanted invalid question wontfix 
do
  echo patching label for ${name}
  name_to_update=${name}
  if [[ $name == 'gfi' ]]; then
     name_to_update_url="good%20first%20issue"
     name_to_update="good first issue"
     c=${name}_color
     color=${!c}
  elif [[ $name == 'helpwanted' ]]; then
     name_to_update_url="help%20wanted"
     name_to_update="help wanted"
     c=${name}_color
     color=${!c}
  else
     name_to_update_url=${name}
     name_to_update=${name}
     c=${name}_color
     color=${!c}
  fi

  json_file=tmp/label.json
  rm -f ${json_file}

  jq -n \
     --arg nm "$name_to_update" \
     --arg color "${color}" \
     '{
        name : $nm,
        color: $color
       }' > ${json_file}

    curl ${curl_custom_flags} \
         -X PATCH \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/$org/${repo}/labels/${name_to_update_url} --data @${json_file}
    rm -f ${json_file}
done
