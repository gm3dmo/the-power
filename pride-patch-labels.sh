.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#update-a-label
# PATCH /repos/:owner/:repo/labels/:name

# There are currently nine labels in "GitHub Issues"
# You know what else has 9 colors?
# Gilbert Bakers 9 stripe pride flag. That's what:
# https://www.crwflags.com/fotw/flags/qq-rb.html#9new


bug_color=cc66ff
documentation_color=ff6699
duplicate_color=ff0000
enhancement_color=ff9900
gfi_color=ffff00
helpwanted_color=009900
invalid_color=0099cc
question_color=330099
wontfix_color=990099

# I feel dirty for doing this in bash.
# Do things in the shell. Get hurt.
# or hurt others by accident.

# Because "good first issue (gfi)" and "help wanted" have spaces in the string
# we have to get a little bit creative:
# it seems like "labels" are the only place in the api where you don't use
# slug to refer to the label but urlencoding it seems to work.

for name in bug documentation duplicate enhancement gfi helpwanted invalid question wontfix 
do
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
