#!/bin/bash
set -x
############# BEGIN USER VALIDATION

MISSING_PUBLIC_EMAIL=0

# If we are on the GitHub Web interface then we don't need to bother to validate the commit user
if [[ ! "${GITHUB_VIA}" == "pull request merge button" ]] &&
   [[ ! "${GITHUB_VIA}" == "blob edit" ]]; then
	GITHUB_USER_EMAIL=`curl -s -k https://127.0.0.1/api/v3/users/${GITHUB_USER_LOGIN} | grep email | sed 's/  \"email\"\: \"//' | sed 's/\",//'`

	if echo "${GITHUB_USER_EMAIL}" | grep "null,"
	then
		PUBLIC_EMAIL_WARNING="WARNING: User does not have public email address set in GitHub Enterprise.\n\nPlease set public email address at https://github.testcom/settings/profile.\n\nFor more information, please see http://u/sod-documentation"
		printf "**********\n" >&2
		printf "${PUBLIC_EMAIL_WARNING}\n" >&2
		printf "**********\n" >&2
		MISSING_PUBLIC_EMAIL=1
	fi
fi

############# END USER VALIDATION

zero_commit="0000000000000000000000000000000000000000"

PROTOTYPE_ENABLED_ORG="EntDevOps"
orgname="${GITHUB_REPO_NAME%%/*}"

if [ "${orgname}" = "${PROTOTYPE_ENABLED_ORG}" ]; then
    exit 0
fi

ISO_EXCEPTION_ORGS=("isoorg")
for iso_exception_org in "${ISO_EXCEPTION_ORGS[@]}"
do
	if [ "${orgname}" = "${iso_exception_org}" ]; then
    	exit 0
	fi
done

TEMP_EXCEPTION_ORGS=("exceptedOrg1")
for temp_exception_org in "${TEMP_EXCEPTION_ORGS[@]}"
do
	if [ "${orgname}" = "${temp_exception_org}" ]; then
    	exit 0
	fi
done

TEMP_EXCEPTION_REPOS=("acme/exception1" "acme/exception2")
for temp_exception_repo in "${TEMP_EXCEPTION_REPOS[@]}"
do
	if [ "${GITHUB_REPO_NAME}" = "${temp_exception_repo}" ]; then
    	exit 0
	fi
done

KNOWN_SECRET_FILES=("OpenSSH private key")

## When adding patterns, make sure to prevent self matching queries so the PRH doesn't get blocked by itself

NULLSHA="0000000000000000000000000000000000000000"
aws="(AWS|aws|Aws)+_?" quote="(\"|')" connect="\s*(:|=>|=)\s*" opt_quote="${quote}?"
PATTERN_AWS_ACCESS_KEY="${opt_quote}${aws}(ACCESS|access|Access)+_?(KEY|key|Key)${opt_quote}${connect}${opt_quote}[A-Z0-9]{16,20}${opt_quote}"
PATTERN_AWS_SECRET_KEY="${opt_quote}${aws}(SECRET|secret|Secret)+_?(ACCESS|access|Access)?_?(KEY|key|Key)${opt_quote}${connect}${opt_quote}[A-Za-z0-9/\+=]{40}${opt_quote}"
PATTERN_GATEWAY_SECRET="${opt_quote}(CLIENT|client|Client)[\_\-\.]?(SECRET|secret|Secret)${opt_quote}\s*[:=\(]\s*${opt_quote}(cleartext[(])?([a-f0-9]{16,})${opt_quote}"
PATTERN_TD_LOGON="\.logon[[:space:]]oneview\/[A-Za-z]{3}[0-9]{3},.{8,}"
PATTERN_CURL_SECRET="curl.{0,256}[[:space:]]\-u[[:space:]][A-Za-z]{3}[0-9]{3}\:.{8,}"
PATTERN_PROXY_SECRET="http\:\/\/[A-Za-z]{3}[0-9]{3}\:.{8,}\@.{0,256}"
PATTERN_DEVEX_SECRET="(secretkey|secretKey)+${opt_quote}${connect}${opt_quote}[A-Za-z0-9]{16,}"

## Blocks Private RSA, DSA, EC, PRIVATE, ECDSA, PGP, OPENSSH Keys
PATTERN_PRIVATE_KEY="BEGIN[[:space:]]((RSA|DSA|EC|ECDSA|PGP|OPENSSH)[[:space:]]|)PRIVATE[[:space:]]KEY"

## Block Critical Java library
PATTERN_JAVA_LIBRARY="import[[:space:]]org\.springframework\.remoting\.httpinvoker\..{1,}"

## File specific patterns
PATTERN_GRADLE_PROXY_PASSWORD="(http\.proxyPassword|https\.proxyPassword)=(\w+?)"
PATTERN_SECRETS_PROPERTIES=".*(PASSWORD|password|Password){1}=.{8,}"

## Warning patterns (Added 8/19/2019)
# Visa cards start with 4, 13 or 16 digits
PATTERN_PCI_VISA="(^|,|[[:space:]])4[0-9]{3}([[:space:]]|\-|)[0-9]{4}([[:space:]]|\-|)[0-9]{4}([[:space:]]|\-|)([0-9]{4}|[0-9]{1})($|,|[[:space:]])"
# Master cards start with 51 - 55 or 2221 - 2720, 16 digits
PATTERN_PCI_MASTERCARD="(^|,|[[:space:]])(5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)([[:space:]]|\-|)[0-9]{4}([[:space:]]|\-|)([[:space:]]|\-|)[0-9]{4}([[:space:]]|\-|)([[:space:]]|\-|)[0-9]{4}([[:space:]]|\-|)($|,|[[:space:]])"
# Amex cards start with 34 or 37, 15 digits
PATTERN_PCI_AMEX="(^|,|[[:space:]])3[47][0-9]{13}($|,|[[:space:]])"
# Discover cards start with 6011 or 65, 16 digits
PATTERN_PCI_DISCOVER="(^|,|[[:space:]])6(011|5[0-9]{2})[0-9]{12}($|,|[[:space:]])"
# Diners Club begin with 300-305, 36 or 38, 14 digits (Some Diners club have MasterCard similar patterns that would be caught by the above Mastercard regex)
PATTERN_PCI_DINER="(^|,|[[:space:]])3(0[0-5]|[68][0-9])[0-9]{11}($|,|[[:space:]])"

# Google API Keys (YouTube, Gmail GDrive, GCP)
PATTERN_GOOGLE_API="${connect}${opt_quote}AIza[0-9A-Za-z\-_]{35}${opt_quote}"
# Google OAuth ID (OAuth secret, OAuth code, OAuth refresh token, OAuth access token)
PATTERN_GOOGLE_OAUTH="${connect}${opt_quote}(1/[0-9A-Za-z\-_]{43}|1/[0-9A-Za-z\-_]{64}|4/[0-9A-Za-z\-_]{30}|ya29\.[0-9A-Za-z\-_]+)${opt_quote}"
# Twitter Tokens
# PATTERN_TWITTER_TOKEN="${connect}${opt_quote}(([1-9][0-9]+-[0-9a-zA-Z]{40})|([0-9a-zA-Z]{45}))${opt_quote}"
# FB Tokens
PATTERN_FB_TOKEN="${connect}${opt_quote}EAACEdEose0cBA[0-9A-Za-z]+${opt_quote}"
# GH Token
PATTERN_GH_TOKEN=".{0,256}https://([a-z0-9]{40})(\:x-oauth-basic|)@github\.(cloud|kdc)\.capitalone.com.{0,256}"

# PATTERN_GATEWAY_SECRET without any length limitation
PATTERN_GATEWAY_SECRET_WARNING="${opt_quote}(CLIENT|client|Client)[\_\-\.]?(SECRET|secret|Secret)${opt_quote}\s*[:=\(]\s*${opt_quote}(cleartext[(])?([a-f0-9]{16,})${opt_quote}"

# PATTERN_DEVEX_SECRET without any length limitation
PATTERN_DEVEX_SECRET_WARNING="(secretkey|secretKey)+${opt_quote}${connect}${opt_quote}[A-Za-z0-9]{16,}"

# OPENSSH PRIVATE KEY
PATTERN_OPENSSH_PRIVATE_KEY="BEGIN[[:space:]]OPENSSH[[:space:]]PRIVATE[[:space:]]KEY"


#Bearer token
PATTERN_BEARER_TOKEN="eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwicGNrIjoxLCJhbGciOiJkaXIiLCJ0diI6Miwia[2]lkIjoicjRxIn0" #brackets are to prevent self matching

#Campaign patterns

#Unified Power Format encrypted password and salt value exposure from Red Team Campaign
PATTERN_UPF_PASSWORD="v\\{ap1t\\\$a1@#%@N\\$|\\{ap1t\\\$a1@#%@N\\$" 	#password
PATTERN_UPF_SALT="\[#B@5\}a\{R"

PATTERN_ARTIFACTORY_PASSWORD="<password>AP.*</password>"
PATTERN_OPENTOKEN_PASSWORD="DKm2y6a0ajZmPjLPKHSJhQ==|V\+QyBsBPm6lOXmCMf7dqbg==|pviklIT\+LI0="

PATTERN_EXCHANGE_CLIENT_SECRET="(SECRET|secret|Secret).*[^a-f0-9][a-f0-9]{32}([^a-f0-9]|$)"

EXIT=0

## Variables related to logging invocation
STRT_DELIM="XiX-HKSTART-XiX" ## Pattern to prepend to all curls sent to haproxy for logging invocations
SP_DELIM="XiX-PRHooK-XiX" ## Pattern to prepend to all curls sent to haproxy for logging invocations
TIMEOUT_EXIT_PAT="ABORT_OVER_MAXSIZE" ## PATTERN FOR WHEN OVER MAX number of files/refs  TO CHECK SO HOOK IS ABORTED
CURL_URL_BASE="http://127.0.0.1"
CURL_TARGET="$CURL_URL_BASE/api/v3/search/code?q="
CURL_HEADER="-H 'Accept: application/vnd.github.v3.text-match+json'"
ABORT=0
ABORT_CODE="NOCANCEL"
FOUND_SENSITIVE="NO_SECRETS"
FINAL_STATUS="$FOUND_SENSITIVE"
COMMIT_TIMESTAMP=$(date +%s)

SVN_MAPPING_REFNAME="refs/__gh__/svn/v4"
MAX_ALLOWED_REFS=30
MAX_ALLOWED_FILES=30
MAX_ALLOWED_FILESIZE=10000

## Return codes for process_files function
RETURN_CODE_PRIVATE_REPO=0
RETURN_CODE_MAX_FILES=1
RETURN_CODE_SENSITIVE_WARNING=2
RETURN_CODE_SENSITIVE_DETECTED=3

load_failure_patterns() {
	echo "${PATTERN_AWS_ACCESS_KEY}"
	echo "${PATTERN_AWS_SECRET_KEY}"
	echo "${PATTERN_PRIVATE_KEY}"
	echo "${PATTERN_TD_LOGON}"
	echo "${PATTERN_GATEWAY_SECRET}"
	echo "${PATTERN_CURL_SECRET}"
	echo "${PATTERN_PROXY_SECRET}"
	echo "${PATTERN_DEVEX_SECRET}"
	echo "${PATTERN_PCI_VISA}"
	echo "${PATTERN_PCI_MASTERCARD}"
	echo "${PATTERN_PCI_AMEX}"
	echo "${PATTERN_PCI_DISCOVER}"
	echo "${PATTERN_PCI_DINER}"
	echo "${PATTERN_GOOGLE_API}"
	echo "${PATTERN_BEARER_TOKEN}"
	echo "${PATTERN_GOOGLE_OAUTH}"
	echo "${PATTERN_GH_TOKEN}"
	echo "${PATTERN_ARTIFACTORY_PASSWORD}"
	echo "${PATTERN_OPENTOKEN_PASSWORD}"
}

load_warning_patterns()   {
	: #Empty command
	# echo "${PATTERN_TWITTER_TOKEN}"
	echo "${PATTERN_FB_TOKEN}"
	echo "${PATTERN_EXCHANGE_CLIENT_SECRET}"
}

# All file patterns block - no warnings
load_file_patterns(){
  	case "${1}" in
		"gradle.properties")
			echo "${PATTERN_GRADLE_PROXY_PASSWORD}"
			echo "${PATTERN_SECRETS_PROPERTIES}"
			;;
		"secrets.properties")
			echo "${PATTERN_SECRETS_PROPERTIES}"
			;;
		 *)
			: #Empty command
			;;
	esac
}

load_campaign_patterns() {
	echo "${PATTERN_UPF_PASSWORD}"
	echo "${PATTERN_UPF_SALT}"
}

load_combined_failure_patterns() {
	local patterns=$(load_failure_patterns)
	echo $(load_combined_patterns "${patterns[@]}")
}

load_combined_warning_patterns() {
	local patterns=$(load_warning_patterns)
	echo $(load_combined_patterns "${patterns[@]}")
}

load_combined_file_patterns(){
	local patterns=$(load_file_patterns "${1}")
	echo $(load_combined_patterns "${patterns[@]}")
}

load_combined_campaign_patterns() {
	local patterns=$(load_campaign_patterns)
	echo $(load_combined_patterns "${patterns[@]}")
}

# load patterns and combine them with |
load_combined_patterns(){
	local patterns=$1
	local combined_patterns=''
	for pattern in $patterns
	do
		combined_patterns=${combined_patterns}${pattern}"|"
	done
	combined_patterns=${combined_patterns%?}
	echo $combined_patterns
}

# given a scan result code, output the appropriate message to the console
print_message() {
	exitCode=0
	messageCode=$1

	if [ "${messageCode}" = "${RETURN_CODE_SENSITIVE_WARNING}" ]; then
		WARNING="WARNING: Some of the files in your commit may contain sensitive data.  Please review"
		WARNING="${WARNING} these files to ensure that secrets such as plain-text credentials, private keys,"
		WARNING="${WARNING} customer data, and Corp confidential/proprietary information are not"
		WARNING="${WARNING} being added to GitHub.  Please Note: the pattern that matched your commit is currently"
		WARNING="${WARNING} compromise by removing any sensitive information that you accidentally just uploaded."
		WARNING="${WARNING} Once testing is complete in the coming weeks, the matching pattern will be moved to"
		WARNING="${WARNING} BLOCK mode and you will be unable to push this type of commit. Please remediate your"
		WARNING="${WARNING} code now to avoid potential impact to future development."
		echo "**********" >&2
		echo "${WARNING}" >&2
		echo "**********" >&2
	fi

	if [ "${messageCode}" = "${RETURN_CODE_SENSITIVE_DETECTED}" ]; then
		ERROR="ERROR: This commit was blocked because at least one of the files being uploaded appears to contain"
		ERROR="${ERROR} sensitive data. Please review these files to ensure that secrets such as plain-text"
		ERROR="${ERROR} credentials, private keys, customer data, and Corp confidential/proprietary"
		echo "**********" >&2
		echo "${ERROR}" >&2
		echo "**********" >&2

		exitCode=1
	fi

	echo "${exitCode}"
}

# given a pattern, a commit reference, and a file, returns whether the pattern matches the file contents
git_grep() {
	pattern=$1
	newref=$2
	file=$3
	git grep -nwHEI "${pattern}" ${newref}:"${file}" >&2
	return $?
}

git_grep_no_word() {
	pattern=$1
	newref=$2
	file=$3
	git grep -nHEI "${pattern}" ${newref}:"${file}" >&2
	return $?
}

# given two commit references, returns the files modified
git_diff() {
	oldref=$1
	newref=$2
	git diff --stat --name-only --diff-filter=ACMRT ${oldref}..${newref}
	return $?
}

# given a commit reference and a file, returns the size of the change
git_filesize() {
	newref=$1
	file=$2
	echo $(git show ${newref}:"${file}" | wc -c  | awk '{print $1}')
	return 0
}

# check based on file magic
has_sensitive_file_types(){
	git_files=$(git ls-files)
	total_files=0

	for git_file in $git_files; do
		let "total_files++"
		if [ "${total_files}" -gt "${MAX_ALLOWED_FILES}" ]; then
			break;
		fi

		for i in "${KNOWN_SECRET_FILES[@]}"; do
			if file $git_file | grep "$i"; then
				return 1
			fi
		done
	done
	return 0
}


is_not_test() {
	if [[ -z "${AUTOMATED_TESTING+x}" ]]; then
		true
	else
		false
	fi
}

# load warning and failure patterns for all files
combined_warning_patterns_for_scan=$(load_combined_warning_patterns)
combined_failure_patterns_for_scan=$(load_combined_failure_patterns)
combined_campaign_patterns_for_scan=$(load_combined_campaign_patterns)

# main function used to process a file for vulnerabilities
# The return code is printed out since bash functions only return 0 or 1
# This function can return 0, 1, 2 or 3
process_files() {
	returnCode="$RETURN_CODE_PRIVATE_REPO"
	COMMIT_SHA=""
	numOfFilesChecked=0
	numOfRefsChecked=0

	# Read stdin for ref information
	while read oldref newref refname; do
		COMMIT_SHA=$newref

		# Exit out of the loop if this commit contains more than $MAX_ALLOWED_FILES or $MAX_ALLOWED_REFS (this prevents against timeouts)
		if [[ "${numOfFilesChecked}" = "${MAX_ALLOWED_FILES}" || "${numOfRefsChecked}" = "${MAX_ALLOWED_REFS}" ]]; then
			returnCode="$RETURN_CODE_MAX_FILES"
			break;
		fi

		let "numOfRefsChecked++"

		# Skip SVN mapping data
		if [ "${refname}" = "${SVN_MAPPING_REFNAME}" ]; then
			continue;
		fi

		# Skip branch deletions
		if [ "${newref}" = "${NULLSHA}" ]; then
			continue;
		fi

		# Set oldref properly if this is branch creation.
		if [ "${oldref}" = "${NULLSHA}" ]; then
			oldref="HEAD"
		fi

		#### SENSITIVE DATA CHECK

		# switching internal field separator to just separate on newline (ignore space and tabs)
		OIFS="$IFS"
		IFS=$'\n'

		# Get list of files to look at using git diff
		for file in $(git_diff ${oldref} ${newref}); do

			if [ "$numOfFilesChecked" -lt "$MAX_ALLOWED_FILES" ]; then
				fileSize=$(git_filesize "${newref}" "${file}")

				# if file size is under or equal to allowed size, continue to scan
				if [ "$fileSize" -le "$MAX_ALLOWED_FILESIZE" ]; then
					# have a check for the file specific patterns
					combined_file_patterns_for_scan=$(load_combined_file_patterns "${file}")

					if [[ ${file} == *".keytab"* ]]; then
						echo "ERROR: the file "${file}" cannot be committed as files with the .keytab extension are a security vulnerability." >&2
						returnCode="$RETURN_CODE_SENSITIVE_DETECTED"
						break;
					fi

					if git_grep_no_word "${combined_campaign_patterns_for_scan}" "${newref}" "${file}"; then
						echo "WARNING: "${file}" contains sensitive data and will be blocked in the future." >&2
						returnCode="$RETURN_CODE_SENSITIVE_WARNING"
					fi

					if	git_grep "${combined_warning_patterns_for_scan}" "${newref}" "${file}"; then
						echo "WARNING: "${file}" contains sensitive data and will be blocked in the future." >&2
						returnCode="$RETURN_CODE_SENSITIVE_WARNING"
					fi

					if git_grep "${combined_file_patterns_for_scan}" "${newref}" "${file}" || \
						 git_grep "${combined_failure_patterns_for_scan}" "${newref}" "${file}"; then
						echo "ERROR: "${file}" contains sensitive data and may not be added to GitHub." >&2
						returnCode="$RETURN_CODE_SENSITIVE_DETECTED"
						break;
					fi
				fi
			else
				# break from loop if $MAX_ALLOWED_FILES checked
				returnCode="$RETURN_CODE_MAX_FILES"
				break;
			fi

			# only check upto $MAX_ALLOWED_FILES regardless of whether they are above the allowed FILE_SIZE or not
			let "numOfFilesChecked++"
		done
		# switching back to default internal field separator
		IFS="$OIFS"
	done

	# Following two values are returned
	# 1) printing out COMMIT_SHA for pre-receive-hook logging
	# 2) returnCode can be 0, 1, 2, 3
	#    if returnCode = 0 or 1, no commit contents met our search patterns, so this commit can proceed!
	#    if returnCode = 2, then sensitive warnings
	#    if returnCode = 3, block
	echo "${COMMIT_SHA}" "${returnCode}"
}

# execute if this is called from git hook, but not from automated tests
if is_not_test ; then
	# process files for this commit
	read COMMIT_SHA returnCode < <(process_files)

	if [ "${returnCode}" = "${RETURN_CODE_SENSITIVE_DETECTED}" ]; then
		FOUND_SENSITIVE="DETECTED_SENSITIVE_DATA"
		FINAL_STATUS="$FOUND_SENSITIVE"
	elif [ "${returnCode}" = "${RETURN_CODE_SENSITIVE_WARNING}" ]; then
		FINAL_STATUS="SENSITIVE_WARNING"
	elif [ "${returnCode}" = "${RETURN_CODE_MAX_FILES}" ]; then
		ABORT=1
		ABORT_CODE="$TIMEOUT_EXIT_PAT"
		FINAL_STATUS="$ABORT_CODE"
	fi

	# print a result message, if any
	# exitCode = 1 if block-worthy sensitive data is found
	read exitCode < <(print_message "$returnCode")

	### Send curl to the instance, to log the invocation to the haproxy log.
	export CURL_MSG="${SP_DELIM}+${GITHUB_REPO_NAME}+$COMMIT_SHA+${GITHUB_USER_LOGIN}+ABRT=$ABORT+STATUS=${FINAL_STATUS}+EXEC_SECONDS=$SECONDS+EPOCH=$COMMIT_TIMESTAMP+MISSING_PUBLIC_EMAIL=$MISSING_PUBLIC_EMAIL "
	export CURL=`curl -k -s $CURL_HEADER ${CURL_TARGET}$CURL_MSG  2>&1`

	## Now exit
	exit ${exitCode}
fi
