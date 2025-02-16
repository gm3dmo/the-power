.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/issues/comments?apiVersion=2022-11-28#create-an-issue-comment
# POST /repos/{owner}/{repo}/issues/{issue_number}/comments


# See this link for information about autolinked references:
# https://docs.github.com/en/get-started/writing-on-github/working-with-autolinks_documentation="advanced-formatting/autolinked-references-and-urls#issues-and-pull-requests"
autolinks_documentation_sha="https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls#commit-shas"
lorem_append="<p>The (@${org}/${team_slug}) will be interested in this.<p> Especially (@${default_committer}) because they love solving issues. <p><p>Does anybody think it's possible that #${default_pull_request_id} could be causing this? or #17 if that even exists yet.<P><P>It's possible to add other links here. As per the ${autolinks_documentation_sha}<P><P> Tests SHA: (${head_sha}).<P><P> Tests Username/Repository@SHA: (${org}/${repo}@${head_sha})"


if [ -z "$1" ]
  then
    issue_id=${default_issue_id}
  else
    issue_ido=$1
fi

lorem_file="lorem-issue-comment.md"
lorem_text=$(cat $lorem_file)
head_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch}| jq -r '.object.sha')


json_file="tmp/issue-comment.json"
jq -n \
      --arg body "${lorem_text}${lorem_append}" \
            '{
               body: $body
             }' > ${json_file}


curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.full+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/issues/${issue_id}/comments" -d @${json_file}

