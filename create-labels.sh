.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/issues#create-a-label
# POST /repos/:owner/:repo/labels

_bug_color=FF0018
_duplicate_color=FFA52C
_enhancement_color=FFFF41
_helpwanted_color=008018
_invalid_color=0000F9
_question_color=86007D
_wontfix_color=FF1B8D

# I feel dirty for doing this in bash:
# Do things in the shell. Get hurt.
for i in _bug,'its a bug' _duplicate,'this is a duplicate' _enhancement,'enhance me'  _helpwanted,'help me' _invalid,'invalid thing here' _question,'i have questions' _wontfix,'jim wont fix it';do
  nm=${i%,*};
  description=${i#*,};
  c=${nm}_color
  color=${!c}
  json_file=tmp/label.json
  rm -f ${json_file}

  jq -n \
     --arg nm "$nm" \
     --arg description "$description" \
     --arg color "${color}" \
     '{
        name : $nm,
        description: $description,
        color: $color 
       }' > ${json_file}
     cat ${json_file}

    curl ${curl_custom_flags} \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Content-Type: application/json" \
            ${GITHUB_API_BASE_URL}/repos/$org/${repo}/labels --data @${json_file}
    rm -f ${json_file}
done
