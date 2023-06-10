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

# If you'd like to trace activity through the system
# set this user agent variable:
#
GIT_HTTP_USER_AGENT="the-power"
export GIT_HTTP_USER_AGENT

# In the babeld log you'll now get http_ua=the-power:
# Jun 10 07:40:31 ghe.test.com babeld[3395]: ts=2023-06-10T07:40:31.573371Z pid=1 tid=113 version=80b65cb proto=http id=366d5cb0f378a4f86f5bd64717c10b34 http_url="/acme/testrepo.git/info/refs?service=git-upload-pack" http_ua="the-power" i

cd src
rm -rf ${repo}
git clone https://ghe-admin:${GITHUB_TOKEN}@${hostname}/${org}/${repo}.git
