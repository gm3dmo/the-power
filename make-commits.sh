.  ./.gh-api-examples.conf

export number_of_commits


if [ -d src/${repo} ]; then
    cd src/${repo}
else
    echo clone the repo first
    ./clone-default-repo.sh
fi

pwd
git branch
git checkout ${new_branch}
git branch

mkdir -p make-n-commits
timestamp=$(date +%s)

echo "Creating: ${number_of_commits} commits"
for d in `seq 1 ${number_of_commits}`;
 do 
    filename=make-n-commits/file-${timestamp}-commit-number-${d}.md
    touch ${filename}
    echo $d >> ${filename}
    git add ${filename}  > /dev/null
    git commit -m "adding file: ${filename}" > /dev/null
 done

timestamp_end=$(date +%s)

let "duration_seconds=$timestamp_end - $timestamp"
echo "Creating: ${number_of_commits} commits took ${duration_seconds}"

echo "Running git push: ${number_of_commits} commits"
echo ================================================
git push
echo ================================================
