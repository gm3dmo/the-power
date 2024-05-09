.  ./.gh-api-examples.conf

export number_of_commits

./clone-default-repo.sh

cd src/${repo}
git branch ${branch_name}  origin/${branch_name}
git switch -c ${branch_name}

mkdir make-n-commits
timestamp=$(date +%s)

for d in `seq 1 ${number_of_commits}`;
 do 
    filename=make-n-commits/file-${timestamp}-commit-number-${d}.md
    touch ${filename}
    echo $d >> ${filename}
    git add ${filename}  > /dev/null
    git commit -m "adding file: ${filename}" > /dev/null
 done

echo =====================
date
git push
echo =====================
