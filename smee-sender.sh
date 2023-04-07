.  ./.gh-api-examples.conf

>&2 echo ${webhook_url}

curl ${webhook_url}  --data '{ "woo" : "woo" }' -H 'Content-Type: application/json'

