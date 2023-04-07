.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/reference/repos#list-release-assets
# GET /repos/:owner/:repo/releases/:release_id/assets
#

# Get the registration token for the runner before we cd into the runner download
# directory.
registration_token=$(./create-a-registration-token-for-a-repository.sh | jq -r '.token')

# tag name looks like: v2.299.1
# we use the ##v shell built-in to strip the v off that.

set -x

tag_name=$(./list-runner-latest-release.sh)
runner_version=${tag_name##v}

# Wondering how portable these are across "uname" versions.
runner_platform_uname=$(uname -m)
if [ $runner_platform_uname == 'x86_64' ];
then
   runner_platform="x64"
fi

uname_s=$(uname -s)
if [ $uname_s == "Darwin" ];
then
    runner_os="osx"
elif [ $uname_s == "Linux" ];
then
    runner_os="linux"
fi


if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi


# Clean up the actions runner directory
rm -rf actions-runner
mkdir actions-runner && cd actions-runner

# Download actions runner
curl -O -L https://${hostname}/actions/runner/releases/download/${tag_name}/actions-runner-${runner_os}-${runner_platform}-${runner_version}.tar.gz

# Extract actions runner
tar zxf actions-runner-${runner_os}-${runner_platform}-${runner_version##v}.tar.gz

# This is a gnarly thing to do but saves rewriting how the config file
# gets populated for this one script that uses github.com the runner tarball download
if [ $hostname == "api.github.com" ];
then
  hostname="github.com"
fi

./config.sh --url https://${hostname}/${org}/${repo} --token ${registration_token} --unattended --name ${runner_name} --labels ${runner_labels}  --replace

./run.sh
