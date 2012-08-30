%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/armel-base.common
%env %import ${SABAYON_MOLECULE_HOME:-/sabayon}/molecules/beagleboard-xm.common

# Release desc (the actual release description)
release_desc: armelv7a BeagleBoard xM

# Release Version (used to generate release_file)
release_version: 10

# Specify image file name (image file name will be automatically
# produced otherwise)
image_name: Sabayon_Linux_10_armelv7a_BeagleBoard_xM_8GB.img

# Specify the image file size in Megabytes. This is mandatory.
# To avoid runtime failure, make sure the image is large enough to fit your
# chroot data.
image_mb: 7400

# Path to boot partition data (MLO, u-boot.img etc)
%env source_boot_directory: ${SABAYON_MOLECULE_HOME:-/sabayon}/boot/arm/beagleboard-xm

# External script that will generate the image file.
# The same can be copied onto a MMC by using dd
%env image_generator_script: ${SABAYON_MOLECULE_HOME:-/sabayon}/scripts/beagleboard_xm_image_generator_script.sh
