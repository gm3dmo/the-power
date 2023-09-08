
.  ./.gh-api-examples.conf

# This script is intended to run after build-testcase-secret-scanning

cd src/${repo}
pwd
# We split the token in 2 so that it's never checked in to the power
# in a way that will set off a false positive (hopefully).

ts=$(date +%s)
filename=file-containing.token.compromised.secret-${ts}.txt

# Breaking tokens up to get past a secret scanner is a bad thing
# it will likely get you fired.

function commit_token() {
    echo You are commiting $token
    echo ${#1}
    echo "this is a token: $token" > $filename
    echo -----
    cat $filename
    echo -----
}


echo 
echo "Please type name token to add to a file: "
echo
read token_name
echo "please paste token: "
echo
read token
echo token: $token is length: ${#token}
commit_token
echo 


git add *.txt
git commit -m "Adding compromised key to $file: "
echo
echo press enter to push commit with secret:
echo
read x
git push -v

