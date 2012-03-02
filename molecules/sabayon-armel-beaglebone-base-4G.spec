%import /sabayon/molecules/armel-base.common
%import /sabayon/molecules/beaglebone.common

# Release desc (the actual release description)
release_desc: armelv7a BeagleBone

# Release Version (used to generate release_file)
release_version: 8

# Specify image file name (image file name will be automatically
# produced otherwise)
image_name: Sabayon_Linux_8_armelv7a_BeagleBone_Base_4GB.img

# Specify the image file size in Megabytes. This is mandatory.
# To avoid runtime failure, make sure the image is large enough to fit your
# chroot data.
image_mb: 3800

# Path to boot partition data (MLO, u-boot.img etc)
source_boot_directory: /sabayon/boot/arm/beaglebone

# External script that will generate the image file.
# The same can be copied onto a MMC by using dd
image_generator_script: /sabayon/scripts/beaglebone_image_generator_script.sh
