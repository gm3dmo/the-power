. ../../.gh-api-examples.conf

# You will need to do this in a checked out repository
# about 10000 is the biggest batch I could create.
# Clean the file /tmp/head_branches for each run:

ts=$(date +%s)

for commit in {1..500}
do
   file=file_${ts}_${commit}
   echo 00000_${commit} > ${file}
   git add file_${ts}_${commit}
   git commit -m "adding file: ${file}" 
done

