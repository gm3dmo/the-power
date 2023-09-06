. ../../.gh-api-examples.conf

# You will need to do this in a checked out repository
# about 10000 is the biggest batch I could create.
# Clean the file /tmp/head_branches for each run:

ts=$(date +%s)

for branch in {1..2}
do
   branch_name=branch_${ts}_${branch}
   git branch ${branch_name}
done

