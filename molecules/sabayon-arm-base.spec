# Define an alternative execution strategy, in this case, the value must be
execution_strategy: chroot_to_mmc

# Error script command, executed when something went wrong and molecule has
# to terminate the execution
# error_script: /path/to/some/error_script.sh

# Pre-image building script. Hook called before image file creation
# pre_image_script: /sabayon/scripts/pre_image_script.sh

# Post-image building script. Hook called after image file creation and move
# into destination directory.
# Variables exported:
# IMAGE_PATH = path pointing to the destination image file
# IMAGE_CHECKSUM_PATH = path pointing to the destination image file checksum (md5)
post_image_script: /sabayon/scripts/post_mmc_image_script.sh

# Destination directory for the image path (MANDATORY)
destination_image_directory: /sabayon/images

# Specify image file name (image file name will be automatically
# produced otherwise)
image_name: Sabayon_Linux_DAILY_armv7a_Base.img

# External script that will generate the image file.
# The same can be copied onto a MMC by using dd
image_generator_script: /sabayon/scripts/mkloopcard.txt

# Specify the image file size in Megabytes. This is mandatory.
# To avoid runtime failure, make sure the image is large enough to fit your
# chroot data.
# Example: 5000 (means: ~5GB)
# Example: 15000 (means: ~15GB)
image_mb: 2048

# Directories to remove completely (comma separated)
# paths_to_remove:

# Directories to empty (comma separated)
# paths_to_empty:

# Path to source chroot (mandatory)
source_chroot: /sabayon/sources/armv7l_core-2012

# Path to boot partition data (MLO, u-boot.img etc)
source_boot_directory: /sabayon/beaglebone/boot

# Release file that will be created onto the root filesystem
release_file: /etc/sabayon-edition

# Release string (the actual distro name)
release_string: Sabayon Linux

# Release desc (the actual release description)
release_desc: armv7a Base

# Release Version (used to generate release_file)
release_version: 7
