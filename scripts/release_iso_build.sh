#!/bin/bash

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME
export MAKE_TORRENTS="1"

SABAYON_RELEASE="${1}"
if [ -z "${SABAYON_RELEASE}" ]; then
	echo "${0} <release version>" >&2
	exit 1
fi
shift

export SABAYON_RELEASE
exec "${SABAYON_MOLECULE_HOME}"/scripts/iso_build.sh "release" "$@"
