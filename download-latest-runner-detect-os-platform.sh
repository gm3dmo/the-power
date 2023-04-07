.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/repos#list-release-assets
# GET /repos/:owner/:repo/releases/:release_id/assets
#

# tag name looks like: v2.299.1
# we use the ##v shell built-in to strip the v off that.

set -x

tag_name=$(./list-runner-latest-release.sh)
runner_version=${tag_name##v}

# Wondering how portable these are across "uname" versions.
runner_platform=$(uname -m)

uname_s=$(uname -s)
if [ $uname_s == "Darwin" ];
then
    runner_os="osx"
fi


if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi

curl -O -L https://${hostname}/actions/runner/releases/download/${tag_name}/actions-runner-${runner_os}-${runner_platform}-${runner_version}.tar.gz
