#!/bin/sh

SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"

exec "${SABAYON_MOLECULE_HOME}/scripts/iso_build_locked.sh" "daily_iso_build.sh"
