#!/bin/bash

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME
export MAKE_TORRENTS="1"

exec "${SABAYON_MOLECULE_HOME}"/scripts/iso_build.sh "monthly" "$@"
