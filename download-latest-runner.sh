.  ./.gh-api-examples.conf

# tag name looks like: v2.299.1
# we use the ##v shell built-in to strip the v off that.

tag_name=$(./list-runner-latest-release.sh)
runner_version=${tag_name##v}

if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi

curl -O -L https://${hostname}/actions/runner/releases/download/${tag_name}/actions-runner-${runner_os}-${runner_platform}-${runner_version}.tar.gz
