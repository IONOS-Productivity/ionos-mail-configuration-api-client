#!/bin/bash

# List of required CLI applications
required_cli_apps=(curl jq sed)

# Output file for the API definition
output_file=".ncw-mail-configuration.json"

help() {
	echo "Usage: $0 <host>"
	echo "  host: The host where the API spec is hosted"
	echo "  Example: $0 api.example.lan:10443"
	echo "           export API_SPEC_USER=<user> API_SPEC_PASSWORD=<pass>; ./$0 api.example.lan:10443"
}

# Check if the host argument is provided
if [ $# -eq 0 ]; then
	help
	exit 1
fi

# Check if required CLI applications are installed
for app in "${required_cli_apps[@]}"; do
	which "${app}" >/dev/null
	if [ ! $? -eq 0 ]; then
		echo "[e] ERROR: requirement ${app} is missing"
		exit 1
	fi
done

# Set the API spec host and URL
API_SPEC_HOST=$1
API_SPEC="https://${API_SPEC_HOST}/ncw-mail-notification/api-docs/ConfigurationAPI"
echo "Update API client definition"
echo "API Spec: ${API_SPEC}"

# Initialize current API version
current_api_version=""

# Check if the output file exists and get the current API version
if [ -f "${output_file}" ]; then
	current_api_version=$(jq -r '.info.version' "${output_file}")
fi

# Create a temporary file to store the downloaded API spec
temp_file=$(mktemp)

# Download the API spec
CURL_OPTS="--progress-bar"
if [ "${ALLOW_INSECURE_SSL}" = "1" ]; then
    echo "[w] WARNING: Using --insecure. SSL certificate verification is DISABLED. This is insecure and should only be used for trusted/internal servers." >&2
    CURL_OPTS="${CURL_OPTS} --insecure"
fi
curl ${CURL_OPTS} "${API_SPEC}" > "${temp_file}"

# Check if the download was successful
if [ ! $? -eq 0 ]; then
	echo "Failed to download API spec"
	exit 1
fi

# Check if the temporary file exists
if [ ! -f "${temp_file}" ]; then
	echo "Failed to download API spec"
	exit 1
fi

# Check for bad credentials in the downloaded API spec
if grep -q "Bad credentials" "${temp_file}"; then
	echo "[e] failed to download API spec: Bad credentials"
	exit 1
fi

# Get the remote API version from the downloaded API spec
remote_api_version=$(jq -r '.info.version' "${temp_file}")

# Compare the current and remote API versions
if [ "${current_api_version}" == "${remote_api_version}" ]; then
	echo "API spec is up to date. Local:${current_api_version} Remote:${remote_api_version}"
	read -p "Do you want to overwrite the local API spec? [y/N] " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Skip update"
		exit 0
	fi
fi

# Update the local API spec with the remote version
echo "API spec is outdated. Local:${current_api_version} Remote:${remote_api_version}"
cp "${temp_file}" "${output_file}"

# Pretty print the JSON output file
echo "[i] pretty print ${output_file}"
jq . "${output_file}" > "${output_file}.tmp"
mv "${output_file}.tmp" "${output_file}"

# Sanitize the API spec host URL
echo "Sanitize ${output_file}:"

echo "[i] Sanitize https://${API_SPEC_HOST} with https://API_HOST"
sed -i "s|https://${API_SPEC_HOST}|https://API_HOST|g" "${output_file}"

# Sanitize the title in the API spec
echo "[i] Sanitize title..."
jq '.info.title = "Event Configuration Handler"' "${output_file}" > "${output_file}.tmp"
mv "${output_file}.tmp" "${output_file}"

# Sanitize the description in the API spec
echo "[i] Sanitize description"
jq '.info.description = "This is the API client for the Mail Configuration API"' "${output_file}" > "${output_file}.tmp"
mv "${output_file}.tmp" "${output_file}"

# Sanitize the contact information in the API spec
echo "[i] Sanitize contact"
jq '.info.contact = {}' "${output_file}" > "${output_file}.tmp"
mv "${output_file}.tmp" "${output_file}"

# Drop tags description from the API spec
echo "[i] Drop tags description"
jq 'del(.tags[].description)' "${output_file}" > "${output_file}.tmp"
mv "${output_file}.tmp" "${output_file}"
