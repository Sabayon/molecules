#!/bin/sh

# setup ISOLINUX background
cp /sabayon/remaster/mcs/isolinux/back.jpg "${CDROOT_DIR}/isolinux/back.jpg" || exit 1

# execute parent script
/sabayon/scripts/generic_pre_iso_script.sh MCS || exit 1
