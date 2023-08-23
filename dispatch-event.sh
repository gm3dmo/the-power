.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-dispatch-event
# POST /repos/{owner}/{repo}/dispatches

# This script will send a repository dispatch event. If you have configured
# the simple workflow in the power then sending this event will trigger that
# workflow.

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/dispatch-event.json

jq -n \
        --arg event_type "custom_event_type" \
        '{
          event_type : $event_type,
          client_payload: {}
         }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/dispatches --data @${json_file}
