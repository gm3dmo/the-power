
.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets#metadata-restrictions
# Use for testing rulesets

cd src/${repo}
pwd

ts=$(date +%s)
filename=${ts}.txt

touch ${filename}

git add ${filename}

git commit -m "${required_commit_prefix} some commit text ${ts}"
echo
printf "Press enter to push commit with \033[1;33m${required_commit_prefix}\033[0m commit message:"
read x
git push -v
cd ../..
