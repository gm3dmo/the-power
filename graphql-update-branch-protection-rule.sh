.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/mutations#updatebranchprotectionrule
#

if [[ -z $1 ]]; then
  # This extract will only work with the simple rules in The Power:
  branch_protection_rule=$(./graphql-list-branch-protection-patterns.sh | jq -r '.data.repository.branchProtectionRules.nodes[0].id')
else
 branch_protection_rule=$1
fi

graphql_query=tmp/graphql_query.txt
rm -f ${graphql_query}

cat <<EOF >$graphql_query
mutation {
    updateBranchProtectionRule(
        input: {
            branchProtectionRuleId:"$branch_protection_rule",
            pattern:"main",
            requiresApprovingReviews:false,
            requiredApprovingReviewCount:0,
            dismissesStaleReviews:false,
            requiresCodeOwnerReviews:false,
            requiresStatusChecks:true,
            requiresStrictStatusChecks:false,
            requiredStatusChecks: [
                {
                    appId:"any",
                    context:"abc",
            },
            ]
            requiresConversationResolution:false,
            requiresCommitSignatures:false,
            requiresLinearHistory:false,
            isAdminEnforced:$enforce_admins,
            allowsForcePushes:false,
            allowsDeletions:false,
            }
        ) {
        clientMutationId
    }
}
EOF

json_file=tmp/graphql-payload.json
rm -f ${json_file}
jq -n \
  --arg graphql_query "$(cat $graphql_query)" \
  '{query: $graphql_query}' > ${json_file}

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d @${json_file}

