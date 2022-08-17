. .gh-api-examples.conf

export number_of_commits=10

cd src

git clone https://${U}:${token}@${hostname}/${org}/${repo}.git

cd ${repo}

for d in `seq 1 ${number_of_commits}`;
 do 
 pwd;
 echo $d;
 touch file$d.md;
 echo $d >> file${d}.md
 git add file$d.md;
 git commit -m "adding file $d";
 echo "==============================================="
 time  git push
 echo "==============================================="
 done
