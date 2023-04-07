.  ./.gh-api-examples.conf

json_file=tmp/organization-data.json
rm -f ${json_file}

# Running this script will generate the tmp/longlistoforgs.txt file
./generate-long-list-of-orgs.pl

for org in $(cat tmp/longlistoforgs.txt)
do
  ./create-organization.sh ${org}
done
