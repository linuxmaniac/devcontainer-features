#!/usr/bin/env bash

KSNIFF_VERSION="${VERSION:-"latest"}"

set -e

# Clean up
rm -rf /var/lib/apt/lists/*

architecture="$(uname -m)"
case ${architecture} in
x86_64) architecture="amd64" ;;
aarch64 | armv8*) architecture="arm64" ;;
aarch32 | armv7* | armvhf*) architecture="arm7" ;;
*)
	echo "(!) Architecture ${architecture} unsupported"
	exit 1
	;;
esac

if [ "$(id -u)" -ne 0 ]; then
	echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
	exit 1
fi

# Checks if packages are installed and installs them if not
check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

# Figure out correct version of a three part version number is not passed
validate_version_exists() {
	local variable_name=$1
    local requested_version=$2
	if [ "${requested_version}" = "latest" ]; then requested_version=$(curl -sL https://api.github.com/repos/eldadru/ksniff/releases/latest | jq -r ".tag_name"); fi
	local version_list
    version_list=$(curl -sL https://api.github.com/repos/eldadru/ksniff/releases | jq -r ".[].tag_name")
	if [ -z "${variable_name}" ] || ! echo "${version_list}" | grep "${requested_version}" >/dev/null 2>&1; then
		echo -e "Invalid ${variable_name} value: ${requested_version}\nValid values:\n${version_list}" >&2
		exit 1
	fi
	echo "${variable_name}=${requested_version}"
}

# make sure we have curl
check_packages curl jq ca-certificates unzip make

# make sure version is available
if [ "${KSNIFF_VERSION}" = "latest" ]; then KSNIFF_VERSION=$(curl -sL https://api.github.com/repos/eldadru/ksniff/releases/latest | jq -r ".tag_name"); fi
validate_version_exists KSNIFF_VERSION "${KSNIFF_VERSION}"

# download and install binary
KSNIFF_FILENAME=ksniff.zip
echo "Downloading ${KSNIFF_FILENAME}..."
url="https://github.com/eldadru/ksniff/releases/download/${KSNIFF_VERSION}/${KSNIFF_FILENAME}"
echo "Downloading ${url}..."
curl -sSL https://github.com/eldadru/ksniff/releases/download/"${KSNIFF_VERSION}"/"${KSNIFF_FILENAME}" -o "${KSNIFF_FILENAME}"
mkdir ksniff-install
(
	cd ksniff-install
	unzip ../"${KSNIFF_FILENAME}"
	make install
	mv ~/.kube/plugins/sniff/* /usr/local/bin/
)
rm -rf "${KSNIFF_FILENAME}" ksniff-install

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
