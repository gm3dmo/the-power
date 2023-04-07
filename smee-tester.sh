.  ./.gh-api-examples.conf

>&2 echo ${webhook_url}

date=$(date)

json_file=tmp/smee-tester.json

DATA=$( jq -n \
                --arg power  "The Power" \
                --arg installdate  "${date}" \
                '{ name: $power, installationdate: $installdate }'
)

echo $DATA > ${json_file}
cat ${json_file} | jq -r

curl -v ${webhook_url} -H 'Content-Type: application/json' --data @${json_file}
