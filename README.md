# Molecule data and scripts

Sabayon stuff for build Sabayon Official Images.

## Mottainai task

Sabayon team currently build ISO images through Mottainai tasks that are available
[here](https://github.com/Sabayon/sbi-tasks) and in particular for stable ISO see `iso`
path or for development ISO see `iso-dev` path.

## Build Sabayon ISO images

Hereinafter, how build ISO images in two steps:

1. Check Host System:
  - Docker Service must be active
  - Check support of kernel for squashfs with xz compression
  - Check that all tools needed are available:
    * cdrtools
    * mktorrent-borg
    * postfix (optional and needed for send email)
    * squashfs-tools
    * dev-util/molecule-core
    * dev-util/molecule-plugins

2. Start building through *sabayon_iso_build.sh* script.

```
$# ./scripts/sabayon_iso_build.sh

Sabayon ISO Image Build Script.

./scripts/sabayon_iso_build.sh [action] [opts]

Valid actions: daily, weekly, monthly, dailybase, release.

Available options:

-h|--help               This message.
--pull-skip             Skip pull of docker image
--skip-dev              Skip build of development images (with limbo repository).
--skip-export           For development avoid export of docker image if it is already
                        present.
--only-dev              Build only development images.
--docker-rmi            Enable clean of orphaned Docker images.
--image [NAME]          Build only a specific image. (This option can be used multiple time).
                        Valid value are:
                          * spinbase
                          * gnome
                          * kde
                          * mate
                          * minimal
                          * xfce
                          * lxqt
                          * tarball
                          * gnome-forensics

Environment variables to customize:
SABAYON_DOCKER_SRC_IMAGE
                        Default to sabayon/spinbase-amd64:latest
SABAYON_UNDOCKER_OUTPUTDIR
                        Default to /sabayon/sources/amd64-docker-spinbase.
MOLECULE_TMPDIR         Default to /var/cache/molecule
SABAYON_MOLECULE_HOME   Default to /sabayon
SABAYON_KERNEL_VERSION  Set kernel slot to install on image.
                        Default is 4.14
SABAYON_EXTRA_PKGS      Define additional packages to install
                        on spinbase rootfs.
SABAYON_SOURCE_ISO      Define source ISO to remove from iso directory.
SABAYON_SOURCE_ISO_DEV  Define source ISO-dev to remoe from iso directory.
SABAYON_UNMASK_PKGS     Define additional packages to unmask.
SABAYON_MASK_PKGS       Define additional packages to mask.
SABAYON_ENMAN_REPOS     Define additional enman repository to install
                        on spinbase rootfs.

```

**NOTE**: Every ISO images are based on spinbase rootfs, so to customize kernel version
          (that must be available on Sabayon Repository) it is needed build also spinbase
          ISO image because override of last available kernel is done on inner_script of
          spinbase image.

After build is done ISO images are available under *iso* directory.

### Prepare environment

```

// Get molecules sabayon data
$# git clone https://github.com/Sabayon/molecules.git
$# cd molecules
// Became root
$# sudo su

// Now you can build ISO
$# SABAYON_MOLECULE_HOME=`pwd` ./scripts/sabayon_iso_build.sh daily
```

### Examples

**Build daily spinbase image with kernel 4.9**:

```
$# cd molecules
$# SABAYON_KERNEL_VERSION=4.9 SABAYON_MOLECULE_HOME=`pwd` ./scripts/sabayon_iso_build.sh \
      daily --image spinbase --logfile /tmp/sabayon-build.log \
      --stdout --skip-dev --pull-skip --skip-email
```

Option *--pull-skip* can be used when is already available on local Docker image.

**Build daily Gnome image with kernel 4.9**:
```
$# cd molecules
$# SABAYON_KERNEL_VERSION=4.9 SABAYON_MOLECULE_HOME=`pwd` ./scripts/sabayon_iso_build.sh \
      daily --image spinbase --image gnome --logfile /tmp/sabayon-build.log \
      --stdout --skip-dev --pull-skip --skip-email
```

**Build daily Gnome image with additional packages**:

```
$# cd molecules
$# SABAYON_KERNEL_VERSION=4.9 SABAYON_MOLECULE_HOME=`pwd` \
      SABAYON_EXTRA_PKGS="app-emulation/lxd games-strategy/wesnoth" \
      ./scripts/sabayon_iso_build.sh daily --image spinbase --image gnome \
      --stdout --skip-dev --pull-skip --skip-email

```

**Build daily Gnome image with additional packages from gaming-live community repository**:

```
$# cd molecules
$# SABAYON_KERNEL_VERSION=4.15 SABAYON_MOLECULE_HOME=`pwd` \
      SABAYON_EXTRA_PKGS="media-libs/mesa-9999 x11-libs/libdrm-9999" \
      SABAYON_ENMAN_REPOS="gaming-live" \
      ./scripts/sabayon_iso_build.sh daily --image spinbase --image gnome \
        --stdout --skip-dev --pull-skip --skip-email

```

## List of specs

Main difference between iso with *dev* extension is related with type of repository used
for create image: *dev* use limbo repository otherwise sabayon-weekly it is used.

Hereinafter, list of tree of specs file and dependencies.

`Note`: We try to maintains this documentation aligned but could be out of sync.

```

amd64.common
    |
    |   enlightenment.common
    |    |
    |    |
    +----+> sabayon-amd64-enlightenment.spec
    |
    |   graphic-environment.common
    |      |
    |      |
    |      +---> gnome.common
    |      |      |
    |      |      |
    +-------------+-> sabayon-amd64-gnome.spec
    |      |      |
    +-------------+-> sabayon-amd64-gnome-dev.spec
    |      |
    |      +---> kde.common
    |      |      |
    |      |      |
    +-------------+--> sabayon-amd64-kde-dev.spec
    |      |      |
    +-------------+--> sabayon-amd64-kde.spec
    |      |
    |      |     lxqt.common
    |      |      |
    |      |      |
    +-------------+--> sabayon-amd64-lxqt-dev.spec
    |      |      |
    +-------------+--> sabayon-amd64-lxqt.spec
    |      |
    |      |
    |      +---> mate.common
    |      |      |
    |      |      |
    |      |      |
    +-------------+-> sabayon-amd64-mate-dev.spec
    |      |      |
    +-------------+-> sabayon-amd64-mate.spec
    |      |
    |      |
    |      |     minimal.common
    |      |      |
    |      |      |
    +------+------+-> sabayon-amd64-minimal-dev.spec
    |      |      |
    +------+------+-> sabayon-amd64-minimal.spec
    |      |
    |      |
    |      |     server.common
    |      |      |
    |      |      |
    +-------------+-> sabayon-amd64-server-dev.spec
    |      |      |
    +-------------+-> sabayon-amd64-server.spec
    |      |
    |      |     spinbase.common
    |      |      |
    |      |      |
    |      |      |
    +-------------+-> sabayon-amd64-spinbase-dev.spec
    |      |      |
    +-------------+-> sabayon-amd64-spinbase.spec
    |      |
    |      |     xfce.common
    |      |      |
    |      |      |
    |      |      |
    +------+------+-> sabayon-amd64-xfce-dev.spec
    |      |      |
    +------+------+-> sabayon-amd64-xfce.spec
    |             |
    |   forensicxfce.common
    |     |       |
    |     |       |
    +-----+-------+-----> sabayon-amd64-xfceforensic.spec

```


## List of scripts

  * `bump_sabayon_version.sh`: script for aumatically bumps the version of Sabayon
     ebuilds. Require an input parameter with version to bump.

  * `cdupdate.sh`: script for check Sabayon Live System Image through SHA256.

  * `cleanup_pkgcache.sh`: script for remove tarballs not accessed in the last 30 days.

  * `efikamx_image_generator_script.sh`: script currently not used.
    This script depends on:
      - mkloopcard.sh
      - mkloopcard_efikamx_chroot_hook.sh

  * `generic_post_iso_script.sh`: script used on post processing from molecule for update
    ISO image in order to make it USB bootale out of the box. Included by amd64.common file.
    Require one input argument that define ISO_ARCH variable.
    This script depends on:
      - isohybrid (from syslinux package)
      - md5sum

  * `generic_pre_iso_script.sh`: script used on pre processing from molecule.
    Require one input used for set remaster_type variable.
    This script depends on:
      - pre_iso_script_livecd_hash.sh
      - make_grub_langs.sh
      - make_grub_efi.sh
    Used on templates:
      - mate.common
      - server.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common

  * `gforensic_pre_iso_script.sh`: Script currently not used.
    This script depends on:
      - generic_pre_iso_script.sh

  * `image_error_script.sh`: Script for umount chroot mountpoints.
    Used on spinbase-tarball-template.common.

  * `inner_chroot_script.sh`: Script used by molecule for build process.
    Used on templates:
      - mate.common
      - sabayon-amd64-spinbase-dev.spec
      - server.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common
      - forensicxfce.common

  * `inner_source_chroot_update.sh`: Script used by molecule for build process.
    Used on sabayon_iso_build.sh script.

  * `iso_build.include`: Variable file that define LOCK_TIMEOUT.

  * `sabayon_iso_build.sh`: Script for create iso images.
    Require a mandatory parameter that define action.
    Possible values are "daily", "weekly", "monthly", "dailybase", "release".
    After action it is possible optional one of these options:
      - `--push`: Push image to Sabayon server
      - `--stdout`: Print debug message to stdout
      - `--sleepnight`: Execute build after 22pm and sleep until that hour.
      - `--pushonly`: Push only images
      - `--torrents`: Make torrent files.
    This script depends on:
      - make_torrents.sh
      - make_git_logs.sh

  * `iso_build_locked.sh`: Wrapper of script that handle locking.
    First argument define name of the script to execute when lock is acquired.
    This script depends on:
      - iso_build.include

  * `make_git_logs.sh`: Script for bump log changes between two date of
    Sabayon projects:
      - Sabayon/for-gentoo.git
      - Sabayon/sabayon-distro.git
      - Sabayon/molecules.git
      - Sabayon/entropy.git
      - Sabayon/build.git
      - Sabayon/anaconda.git

  * `make_grub_efi.sh`: Script for generate an EFI-enabled boot structure.

  * `make_grub_langs.sh`: Script for append languages option menu on grub.
    This script depends on:
      - _generate_grub_langs.py

  * `make_toorents.sh`: Script for create .torrent file of isos
    This script use mktorrent-borg tool from net-p2p/mktorrent-borg package.

  * `pre_iso_script_livecd_hash.sh`: Script used for generate sha256 sums
    and push cdupdate.sh inside chroot directory.
    This script depends on:
      - cdupdate.sh

  * `remaster_error_script.sh`: Script used from molecule spec file when
    an error happens.
    Used on templates:
      - mate.common
      - server.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common
      - forensicxfce.common

  * `remaster_generic_inner_chroot_script.sh`: Script used from molecules as
    inner_chroot_script.
    Used on templates:
      - mate.common
      - server.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common
      - forensicxfce.common

  * `remaster_generic_inner_chroot_script_after.sh`: Scritp used from molecules
    as inner_chroot_script_after for disable avahi-daemon, remove install directory
    and some others operations. Used on templates:
      - mate.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common
      - forensicxfce.common

  * `remaster_post.sh`: Script used from molecules as outer_chroot_script_after
    for umount procfs from CHROOT_DIR and packages directory.
    This script depends on:
      - remaster_post_commons.sh
    Used on templates:
      - mate.common
      - server.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common

  * `remaster_post_common.sh`: Common stuff used on outer_chroot_script_after.
    Used by remaster_post.sh e xfce_remaster_post.sh

  * `remaster_pre.sh`: Script used from molecules as outer_chroot_script for
    mount procfs and packages directory.
    Used on templates:
      - mate.common
      - server.common
      - enlightenment.common
      - kde.common
      - xfce.common
      - minimal.common
      - gnome.common
      - lxqt.common
      - forensicxfce.common

  * `remaster_serverbase_inner_chroot_script_after.sh`: Script used from molecules
    as inner_chroot_script_after for Sabayon Server image.

  * `spinbase_pre_iso_script.sh`: Script used as pre_iso_script from molecules for
    Sabayon Spinbase image.
    This script depends on:
      - pre_iso_script_livecd_hash.sh
      - make_grub_efi.sh
      - make_grub_langs.sh

  * `spinbase_tarball_pre_tar_script.sh`: Script used as pre_tar_script from molecules
    for Sabayon Tarball Template.

  * `tar_generic_chroot_script_after.sh`: Script currently not used.

  * `xfce_remaster_post.sh`: Script used as outer_chroot_script_after from molecules
    on create Sabayon Xfce image.
    This script depends on:
      - remaster_post.sh

  * `xfceforensic_pre_iso_script.sh`: Script used as pre_iso_script from molecules
    on create Sabayon Xfce image.
    This script depends on:
      - generic_pre_iso_script.sh

## Scripts Variables

### bump_sabayon_version.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| OVERLAY_BASE_URL | git@github.com:Sabayon | Git overlay base url. |
| OVERLAY_BASE_DIR | ${SABAYON_MOLECULE_HOME} or ${HOME} if is empty | Base directory where pull overlay to use for bump. |

### cdupdate.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| CDROOT | /mnt/cdrom | Path where is mount Live image |

### cleanup_pkgcache.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |

### daily_iso_build.sh, daily_iso_build_locked.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |

### efikamx_image_generator_script.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |


### generic_post_iso_script.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| ISO_CHECKSUM_PATH | - | Path to generated md5 for ISO |
| ISO_PATH | - | path to generated ISO |

### generic_pre_iso_script.sh


| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |
| CDROOT_DIR | - | Path of mounted iso path |

### image_error_script.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| CHROOT_DIR | - | Path of chroot directory |

### iso_build.sh, iso_build_locked.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |

### make_grub_efi.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |
| CHROOT_DIR | - | Path of chroot directory |

### remaster_post.sh

| Env Variable | Default | Description |
|--------------|---------|-------------|
| SABAYON_MOLECULE_HOME | /sabayon | Path of Sabayon molecules data |
| CHROOT_DIR | - | Path of chroot directory |

# Requirements

For build ISO images is required kernel module with squashfs xz compression.

Example of error if module is not present:
```
  squashfs: SQUASHFS error: Filesystem uses "xz" compression. This is not supported
```

