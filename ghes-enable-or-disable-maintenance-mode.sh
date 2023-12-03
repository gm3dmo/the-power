.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.10/rest/enterprise-admin/management-console?apiVersion=2022-11-28#enable-or-disable-maintenance-mode
# POST /setup/api/maintenance


json_file=tmp/enable-or-disable-maintenance-mode

case $1 in
    enable)
	enabled=true
        maint_string='maintenance={ "enabled":true, "when":"now" }'
	;;
    disable)
	enabled=false
        maint_string='maintenance={ "enabled":false, "when":"now" }'
	;;
    *)
	echo "Usage: $0 [enable|disable]"
	exit 1
	;;
esac


set -x
curl -L -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -u "api_key:${admin_password}" \
        "https://${hostname}:${mgmt_port}/setup/api/maintenance" --data-urlencode "${maint_string}"


# The documentation version of this looks like:

# curl -L \
#   -X POST \
#   -H "Accept: application/vnd.github+json" \
#   -u "api_key:your-password" \
#   http(s)://HOSTNAME/setup/api/maintenance \
#    --data-urlencode "maintenance={"enabled":true, "when":"now"}"

# I had to set it in single quotes for it to work.
