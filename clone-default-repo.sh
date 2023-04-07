.  ./.gh-api-examples.conf


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

if [ $hostname == api.github.com ]; then
  hostname=github.com
fi

cd src
rm -rf ${repo}
git clone https://ghe-admin:${GITHUB_TOKEN}@${hostname}/${org}/${repo}.git
