# Read in a config file where reused variables can be stored:
if [ -z "$1" ]
  then
    . ~/.the-power-dotcom.conf
  else
    . $1
fi

# When building testcases it can be nice for them to have their own
# repository to live in. If passed an optional argument
if [ ! -z "$2" ]
  then
    repo=$2
  else
    repo=testrepo
fi

python3 configure.py --hostname "${hostname}" \
                     --enterprise-name "${enterprise_name}" \
                     --org "${org}" \
                     --repo "${repo}" \
                     --repo-webhook-url "${repo_webhook_url}" \
                     --repo-collaborator "${repo_collaborator:-hubot}" \
                     --default-repo-visibility ${default_repo_visibility:-private} \
                     --token "${github_token}" \
                     --app-configure ${app_configure:-no} \
                     --app-id "${app_id}" \
                     --app-client-secret "${app_client_secret:-an_app_client_secret}" \
                     --app-installation-id "${app_installation_id:-an_app_installation_id}" \
                     --app-client-id "${app_client_id:-an_app_client_id}" \
                     --app-private-pem "${app_private_pem:-a_private_pem_file}" \
                     --team-members "${team_members:-team_members_space_separated}" \
                     --team-admin "${team_admin:-a_team_admin}" \
                     --default-committer "${default_committer:-a_default_committer}" \
                     --pr-approver-name "${pr_approver_name:-a_username}" \
                     --pr-approver-token "${pr_approver_token:-a_fine_grained_pat}" \
                     --chrome-profile "${chrome_profile:-a_chrome_profile_number}" \
                     --x-client-id "${x_client_id:-an_ouath_app_client_id}" \
                     --x-client-secret "${x_client_secret:-an_oauth_client_secret}" \
                     --enterprise-app-name "${ent_app_name:-an_enterprise_app_name}" \
                     --enterprise-app-id "${ent_app_id:-an_enterprise_app_id}" \
                     --enterprise-app-pem "${ent_app_private_pem=:-an_enterprise_app_pem}" \
                     --enterprise-app-installation-id "${ent_app_installation_id:-an_enterprise_app_installation_id}" \
                     --enterprise-app-org-installation-id "${ent_app_org_installation_id:-an_enterprise_app_org_installation_id}" \
                     --enterprise-app-client-id "${ent_app_client_id:-an_enterprise_app_client_id}" \
                     --enterprise-app-client-secret "${ent_app_client_secret:-an_enterprise_app_client_secret}" \
                     --curl_custom_flags "--fail-with-body --no-progress-meter" 

