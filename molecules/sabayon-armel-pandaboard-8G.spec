%import /sabayon/molecules/armel-base.common
%import /sabayon/molecules/pandaboard.common

# Release desc (the actual release description)
release_desc: armelv7a PandaBoard

# Release Version (used to generate release_file)
release_version: 8

# Specify image file name (image file name will be automatically
# produced otherwise)
image_name: Sabayon_Linux_8_armelv7a_PandaBoard_8GB.img

# Specify the image file size in Megabytes. This is mandatory.
# To avoid runtime failure, make sure the image is large enough to fit your
# chroot data.
image_mb: 7400

# Path to boot partition data (MLO, u-boot.img etc)
source_boot_directory: /sabayon/boot/arm/pandaboard

# External script that will generate the image file.
# The same can be copied onto a MMC by using dd
image_generator_script: /sabayon/scripts/beagleboard_xm_image_generator_script.sh
