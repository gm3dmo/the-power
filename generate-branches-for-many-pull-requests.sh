. ../../.gh-api-examples.conf

# You will need to do this in a checked out repository
# about 10000 is the biggest batch I could create.
# Clean the file /tmp/head_branches for each run:
> /tmp/head_branches


# for commit in {1..5}
# do
# echo 00000_${commit} > file_00000_${commit}
# git add file_00000_${commit}
# git commit -m "adding file: file_00000_${commit}"
# done

# echo 00000 > file_00000
# git add file_00000
# git commit -m "adding file: file_00000"
# echo  branch_00000 >> /tmp/head_branches
# git checkout

export base_branch


perl  -e '$date = time(); for ("7100".."7105") { printf "git branch branch_%05d\ngit checkout branch_%05d\nfor commit in {1..50}\ndo\n   echo %05d_\${commit} > file_%05d_\${commit}\n   git add file_%05d_\${commit}\n   git commit -m \"adding file: file_%05d_\${commit}\"\ndone\necho  branch_%05d >> /tmp/head_branches\n\ngit checkout $ENV{base_branch}\n",$_,$_,$_,$_,$_,$_,$_ }' >/tmp/longlistofbranches.txt
echo "bash /tmp/longlistofbranches.txt"
echo "Remember to do:"

echo "    git push --all"

echo "to push these branches back to the remote."
