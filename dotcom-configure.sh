# Parse command line arguments
config_file=~/.the-power-dotcom.conf
repo_override=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --config)
      config_file="$2"
      shift 2
      ;;
    --repo)
      repo_override="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--config CONFIG_FILE] [--repo REPO_NAME]"
      exit 1
      ;;
  esac
done

# Read in a config file where reused variables can be stored:
. "$config_file"

# Use command line repo if provided, otherwise use config file value, fallback to testrepo
if [ ! -z "$repo_override" ]; then
  repo="$repo_override"
elif [ -z "$repo" ]; then
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

