#!/bin/bash

set -euo pipefail

# =============================================================================
# Constants
# =============================================================================
readonly REQUIRED_CLI_APPS=(curl jq sed git)
readonly OUTPUT_FILE=".ncw-mail-configuration.json"
readonly API_PATH="/nextcloud/api-docs/Addon%20API"

# =============================================================================
# Global Variables
# =============================================================================
temp_file=""
create_branch=false
branch_name=""

# =============================================================================
# Utility Functions
# =============================================================================

# Cleanup temporary files on exit
cleanup() {
	if [[ -n "${temp_file}" && -f "${temp_file}" ]]; then
		rm -f "${temp_file}"
	fi
}
trap cleanup EXIT

# Print error message and exit
die() {
	echo "[e] ERROR: $*" >&2
	exit 1
}

# Print warning message
warn() {
	echo "[w] WARNING: $*" >&2
}

# Print info message
info() {
	echo "[i] $*"
}

# Ask yes/no question with default answer
# Usage: ask_yes_no "Question?" "Y" or ask_yes_no "Question?" "N"
ask_yes_no() {
	local question=$1
	local default=${2:-Y}
	local prompt="[Y/n]"

	if [[ "${default}" == "N" ]]; then
		prompt="[y/N]"
	fi

	read -p "${question} ${prompt} " -n 1 -r
	echo

	if [[ "${default}" == "Y" ]]; then
		[[ ! ${REPLY} =~ ^[Nn]$ ]]
	else
		[[ ${REPLY} =~ ^[Yy]$ ]]
	fi
}

# Generate branch name from version and timestamp
generate_branch_name() {
	local version=$1
	local version_clean
	local timestamp

	# Replace non-alphanumeric characters (except . and -) with underscore
	version_clean="${version//[^a-zA-Z0-9.-]/_}"
	timestamp=$(date +%Y%m%d%H%M%S)
	echo "feat/api-update-${version_clean}-${timestamp}"
}

# Check if branch exists locally or remotely
# Returns 0 if exists, 1 if not
# Returns two values: branch_exists_local, branch_exists_remote
check_branch_exists() {
	local branch=$1
	local branch_exists_local branch_exists_remote

	branch_exists_local=$(git branch --list "${branch}" | wc -l)
	branch_exists_remote=$(git branch -r --list "origin/${branch}" | wc -l)

	echo "${branch_exists_local} ${branch_exists_remote}"
}

# Display where a branch exists
show_branch_locations() {
	local branch_exists_local=$1
	local branch_exists_remote=$2
	if [[ ${branch_exists_local} -gt 0 ]]; then
		echo "    - Found locally"
	fi
	if [[ ${branch_exists_remote} -gt 0 ]]; then
		echo "    - Found on remote (origin)"
	fi
}

# Show usage information
show_help() {
	cat <<-EOF
		Usage: $0 <host>

		Arguments:
		  host    The host where the API spec is hosted

		Examples:
		  $0 api.example.lan:10443
		  export API_SPEC_USER=<user> API_SPEC_PASSWORD=<pass>; $0 api.example.lan:10443
	EOF
}

# Check if required CLI applications are installed
check_requirements() {
	local missing_apps=()

	for app in "${REQUIRED_CLI_APPS[@]}"; do
		if ! command -v "${app}" >/dev/null 2>&1; then
			missing_apps+=("${app}")
		fi
	done

	if [[ ${#missing_apps[@]} -gt 0 ]]; then
		die "Missing required applications: ${missing_apps[*]}"
	fi
}

# =============================================================================
# Main Functions
# =============================================================================

# Parse command line arguments
parse_args() {
	if [[ $# -eq 0 ]]; then
		show_help
		exit 1
	fi
}

# Get API version from local file
get_local_version() {
	if [[ -f "${OUTPUT_FILE}" ]]; then
		jq -r '.info.version' "${OUTPUT_FILE}" 2>/dev/null || echo ""
	else
		echo ""
	fi
}

# Get API version from origin/main
get_origin_version() {
	local version=""

	# Try to get version from git remote first
	if git cat-file -e origin/main:"${OUTPUT_FILE}" 2>/dev/null; then
		version=$(git show --no-pager origin/main:"${OUTPUT_FILE}" 2>/dev/null | jq -r '.info.version' 2>/dev/null || echo "")
	fi

	# If git didn't work or returned empty, fallback to fetching from GitHub repository
	if [[ -z "${version}" || "${version}" == "null" ]]; then
		local github_url="https://raw.githubusercontent.com/IONOS-Productivity/ionos-mail-configuration-api-client/refs/heads/main/${OUTPUT_FILE}"
		version=$(curl -sf "${github_url}" 2>/dev/null | jq -r '.info.version' 2>/dev/null || echo "")
	fi

	echo "${version}"
}

# Get API version from downloaded spec
get_remote_version() {
	local spec_file=$1
	jq -r '.info.version' "${spec_file}" 2>/dev/null || echo ""
}

# Fetch latest changes from git origin
fetch_from_origin() {
	info "Fetching latest changes from origin..."
	if ! git fetch origin; then
		warn "Warning: git fetch origin failed, continuing..."
	fi
}

# Display version information
display_versions() {
	local current_version=$1
	local origin_version=$2

	info "Current local version: ${current_version:-none}"
	info "Origin/main version: ${origin_version:-none}"
}

# Download API specification from remote server
download_api_spec() {
	local api_spec_host=$1
	local api_spec_url="https://${api_spec_host}${API_PATH}"

	echo "Update API client definition"
	echo "API Spec: ${api_spec_url}"

	temp_file=$(mktemp)

	local curl_opts="--progress-bar"
	if [[ "${ALLOW_INSECURE_SSL:-0}" == "1" ]]; then
		warn "Using --insecure. SSL certificate verification is DISABLED. This is insecure and should only be used for trusted/internal servers."
		curl_opts="${curl_opts} --insecure"
	fi

	# shellcheck disable=SC2086
	if ! curl ${curl_opts} "${api_spec_url}" > "${temp_file}"; then
		die "Failed to download API spec"
	fi

	if [[ ! -f "${temp_file}" ]]; then
		die "Failed to download API spec"
	fi

	if grep -q "Bad credentials" "${temp_file}"; then
		die "Failed to download API spec: Bad credentials"
	fi
}

# Ask user if they want to create a new branch
handle_version_comparison() {
	local current_version=$1
	local origin_version=$2
	local remote_version=$3

	if [[ "${origin_version}" != "${remote_version}" ]]; then
		echo ""
		echo "Remote version (${remote_version}) is different from origin/main (${origin_version:-none})"

		if ask_yes_no "Do you want to create a new branch for this update?" "Y"; then
			create_branch=true
			branch_name=$(generate_branch_name "${remote_version}")
		fi
	elif [[ "${current_version}" == "${remote_version}" ]]; then
		echo ""
		echo "API spec is up to date. Local:${current_version} Remote:${remote_version}"

		if ! ask_yes_no "Do you want to overwrite the local API spec?" "N"; then
			info "Skipping update"
			exit 0
		fi
	fi
}

# Handle branch creation when branch already exists
handle_existing_branch() {
	local branch=$1
	local branch_exists_info
	local branch_exists_local
	local branch_exists_remote

	echo ""
	warn "Branch '${branch}' already exists"

	branch_exists_info=$(check_branch_exists "${branch}")
	read -r branch_exists_local branch_exists_remote <<< "${branch_exists_info}"
	show_branch_locations "${branch_exists_local}" "${branch_exists_remote}"

	echo ""
	echo "What would you like to do?"
	echo "  1) Switch to existing branch"
	echo "  2) Choose a different branch name"
	echo "  3) Abort"
	read -p "Enter your choice [1-3]: " -n 1 -r choice
	echo

	case ${choice} in
		1)
			switch_to_existing_branch "${branch}" "${branch_exists_local}" "${branch_exists_remote}"
			;;
		2)
			prompt_for_branch_name "${branch}"
			;;
		3)
			info "Aborting"
			exit 0
			;;
		*)
			die "Invalid choice. Aborting."
			;;
	esac
}

# Switch to an existing branch (local or remote)
switch_to_existing_branch() {
	local branch=$1
	local branch_exists_local=$2
	local branch_exists_remote=$3

	if [[ ${branch_exists_local} -gt 0 ]]; then
		info "Switching to existing local branch: ${branch}"
		git checkout "${branch}" || die "Failed to switch to branch"
	else
		info "Checking out remote branch: ${branch}"
		git checkout -b "${branch}" "origin/${branch}" || die "Failed to checkout remote branch"
	fi
}

# Prompt for a new branch name and validate it
prompt_for_branch_name() {
	local suggested_name=$1
	local new_name=""
	local current_suggestion="${suggested_name}"
	local branch_exists_info
	local branch_exists_local
	local branch_exists_remote

	while true; do
		echo ""
		info "Suggested branch name: ${current_suggestion}"
		read -r -p "Enter new branch name (or press Enter to use suggested): " new_name

		# Use suggested name if user pressed Enter
		if [[ -z "${new_name}" ]]; then
			new_name="${current_suggestion}"
		fi

		# Check if the new branch name already exists
		branch_exists_info=$(check_branch_exists "${new_name}")
		read -r branch_exists_local branch_exists_remote <<< "${branch_exists_info}"

		if [[ ${branch_exists_local} -gt 0 || ${branch_exists_remote} -gt 0 ]]; then
			warn "Branch '${new_name}' already exists"
			show_branch_locations "${branch_exists_local}" "${branch_exists_remote}"
			echo ""

			if ! ask_yes_no "Try a different name?" "Y"; then
				die "Branch creation cancelled"
			fi

			# Generate a new suggestion with updated timestamp
			local base_name="${suggested_name%-*}"
			current_suggestion=$(generate_branch_name "${base_name}")
		else
			# Branch name is valid and doesn't exist
			branch_name="${new_name}"
			info "Creating new branch: ${branch_name}"
			git checkout -b "${branch_name}" || die "Failed to create branch"
			break
		fi
	done
}

# Create a new branch for the API update
create_update_branch() {
	local branch_exists_info
	local branch_exists_local
	local branch_exists_remote

	if [[ "${create_branch}" != "true" ]]; then
		return 0
	fi

	branch_exists_info=$(check_branch_exists "${branch_name}")
	read -r branch_exists_local branch_exists_remote <<< "${branch_exists_info}"

	if [[ ${branch_exists_local} -gt 0 || ${branch_exists_remote} -gt 0 ]]; then
		handle_existing_branch "${branch_name}"
	else
		info "Creating new branch: ${branch_name}"
		git checkout -b "${branch_name}" || die "Failed to create branch"
	fi
}

# Apply JQ transformation to output file
jq_transform() {
	local filter=$1
	jq "${filter}" "${OUTPUT_FILE}" > "${OUTPUT_FILE}.tmp"
	mv "${OUTPUT_FILE}.tmp" "${OUTPUT_FILE}"
}

# Sanitize the downloaded API specification
sanitize_api_spec() {
	local api_spec_host=$1

	echo "Sanitize ${OUTPUT_FILE}:"

	# Pretty print
	info "Pretty printing JSON..."
	jq_transform '.'

	# Sanitize host URL
	info "Sanitize https://${api_spec_host} with https://API_HOST"
	sed -i "s|https://${api_spec_host}|https://API_HOST|g" "${OUTPUT_FILE}"

	# Sanitize title
	info "Sanitize title..."
	jq_transform '.info.title = "Event Configuration Handler"'

	# Sanitize description
	info "Sanitize description"
	jq_transform '.info.description = "This is the API client for the Mail Configuration API"'

	# Sanitize contact
	info "Sanitize contact"
	jq_transform '.info.contact = {}'

	# Drop tags description
	info "Drop tags description"
	jq_transform 'del(.tags[].description)'
}

# Ask user to regenerate PHP client
ask_regenerate_client() {
	echo ""
	if ask_yes_no "Do you want to run 'make php' to regenerate the PHP client?" "Y"; then
		info "Running 'make php'..."
		if make php; then
			info "PHP client generation completed successfully"
		else
			die "PHP client generation failed"
		fi
	else
		info "Skipping 'make php'. You can run it manually later."
	fi
}

# =============================================================================
# Main Script
# =============================================================================

main() {
	parse_args "$@"
	check_requirements

	local api_spec_host=$1
	local current_version
	local origin_version
	local remote_version

	# Fetch latest from origin
	fetch_from_origin

	# Get version information
	current_version=$(get_local_version)
	origin_version=$(get_origin_version)

	# Display current versions
	display_versions "${current_version}" "${origin_version}"

	# Download API spec
	download_api_spec "${api_spec_host}"

	# Get remote version
	remote_version=$(get_remote_version "${temp_file}")
	info "Remote API version: ${remote_version}"

	# Handle version comparison and branching
	handle_version_comparison "${current_version}" "${origin_version}" "${remote_version}"

	# Create branch if needed
	create_update_branch

	# Update local file
	info "Updating API spec to version ${remote_version}"
	cp "${temp_file}" "${OUTPUT_FILE}"

	# Sanitize the spec
	sanitize_api_spec "${api_spec_host}"

	echo ""
	info "API definition updated and sanitized successfully"
	info "New version: ${remote_version}"

	# Ask to regenerate client
	ask_regenerate_client

	# Final message
	echo ""
	info "Done! Don't forget to review and commit your changes."
	if [[ "${create_branch}" == "true" ]]; then
		info "You are now on branch: ${branch_name}"
	fi
}

main "$@"
