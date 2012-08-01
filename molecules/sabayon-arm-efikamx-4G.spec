%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/arm-base.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/efikamx-showcase.common

# Release desc (the actual release description)
release_desc: armv7a Efika MX

# Release Version (used to generate release_file)
release_version: 9

# Specify image file name (image file name will be automatically
# produced otherwise)
image_name: Sabayon_Linux_9_armv7a_EfikaMX_4GB.img

# Specify the image file size in Megabytes. This is mandatory.
# To avoid runtime failure, make sure the image is large enough to fit your
# chroot data.
image_mb: 3800

# Path to boot partition data (MLO, u-boot.img etc)
%env source_boot_directory: ${SABAYON_MOLECULE_HOME:-/sabayon}/boot/arm/efikamx

# External script that will generate the image file.
# The same can be copied onto a MMC by using dd
%env image_generator_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/efikamx_image_generator_script.sh
