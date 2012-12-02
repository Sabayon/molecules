#!/bin/bash
# Expected env variables:
# CHROOT_DIR
# CDROOT_DIR
# Expected argument: <path to grub.cfg>

GRUB_CFG="${1}"
if [ -z "${GRUB_CFG}" ]; then
    echo "Invalid arguments" >&2
    exit 1
elif [ ! -f "${GRUB_CFG}" ]; then
    echo "${GRUB_CFG} does not exist" >&2
    exit 1
fi

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

echo >> "${GRUB_CFG}" || exit 1
"${SABAYON_MOLECULE_HOME}"/scripts/_generate_grub_langs.py >> "${GRUB_CFG}"
