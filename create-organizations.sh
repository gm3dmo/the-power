.  ./.gh-api-examples.conf

# Used to create an instance with multiple organizations.

for org in ${organizations}
do
 >&2  echo creating $org
 bash create-organization.sh $org
done
