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

# Set tracing debuggging settings if needed.
# youll need to uncomment the export below.
GIT_CURL_VERBOSE=1
GIT_TRACE=true
GIT_TRACE_PERFORMANCE=true
GIT_TRACE_SETUP=true
GIT_TRACE_PACKET=true
# uncomment the export line below to put settings into effect when running git commands:
# export GIT_SSH_COMMAND GIT_CURL_VERBOSE GIT_TRACE GIT_TRACE_PERFORMANCE GIT_TRACE_SETUP GIT_TRACE_PACKET GIT_CURL_VERBOSE

## The GIT_CURL_VERBOSE will give you the x-github-request-id
export GIT_CURL_VERBOSE

# See this url:
# https://github.blog/2012-09-21-easier-builds-and-deployments-using-git-over-https-and-oauth/

cd src
rm -rf ${repo}
git clone https://${GITHUB_TOKEN}:x-oauth-basic@${hostname}/${org}/${repo}.git
