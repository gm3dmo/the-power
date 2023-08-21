.  ./.gh-api-examples.conf

./generate-long-list-of-repos.pl

for org in $(cat tmp/longlistoforgs.txt)
do
    >&2 echo Creating repos for organization: ${org} 
    for repo_name in $(cat tmp/longlistofrepos.txt)
    do
         >&2 echo Creating repo: "${org}/${repo_name}"
         ./create-repo.sh ${repo_name} ${org}
    done
done
