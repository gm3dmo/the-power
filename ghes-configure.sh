# Read in a config file where reused variables can be stored:
if [ -z "$1" ]
  then
    . ~/.the-power-ghes.conf
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

python3 configure.py --hostname ${hostname} \
                     --enterprise-name ${enterprise_name} \
                     --org ${org} \
                     --repo ${repo} \
                     --token ${github_token} \
		     --admin-password ${admin_password} \
                     --webhook-url ${webhook} \
                     --configure-app yes \
                     --app-id ${app_id} \
                     --installation-id ${installation_id} \
                     --client-id ${app_client_id} \
                     --team-members "${team_members}" \
                     --team-admin "${team_admin}" \
                     --default-committer "${default_committer}" \
                     --private-pem-file ${private_pem_file} \
                     --pr-approver-token ${pr_approver_token}
