.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/admin/monitoring-activity-in-your-enterprise/exploring-user-activity-in-your-enterprise/accessing-reports-for-your-instance#downloading-reports-programmatically

curl_custom_flags='--write-out "%output{tmp/variables.json}%{json}%output{tmp/header.json}%{header_json}'

# scriptname=$(basename "$0")
# while IFS= read -r line; do
# echo $line
# done < $scriptname
# exit

clear
echo "===== Sitem Admin Dashboard Reports ====="
echo
echo "Choose a report to download:"
echo
options=("all_users.csv" "all_repositories.csv")

# Print menu options with indentation
for i in "${!options[@]}"; do
    printf "   %d) %s\n" $((i+1)) "${options[$i]}"
done

echo
while true; do
    read -p "Please enter your choice: " choice
    if [[ $choice -ge 1 && $choice -le ${#options[@]} ]]; then
        report_name="${options[$((choice-1))]}"
        break
    else
        echo "Invalid option. Try again."
    fi
done

report_file="tmp/${report_name}"

curl ${curl_custom_flags} -u ${admin_user}:${GITHUB_TOKEN} \
     "https://${hostname}/stafftools/reports/${report_name}"  -o ${report_file}

echo
echo "========== tmp/variables.json ==================="
echo

  http_code=$(jq -r  '.http_code' tmp/variables.json)
  printf "   http_code: %s\n"  "${http_code}"
  
echo
echo "========== tmp/header.json ==================="
echo

  xg=$(jq -r '."x-github-request-id"[0]' tmp/header.json)
  printf "   x-github-request-id: %s\n"  "${xg}"

echo

echo
echo "========== ${report_file} ==================="
ls -l ${report_file}


