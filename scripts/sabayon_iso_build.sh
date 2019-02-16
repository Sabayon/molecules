#!/bin/bash

# Initialize script variables
SOURCE_SPECS=()
SOURCE_SPECS_ISO=()
REMASTER_SPECS=()
REMASTER_SPECS_ISO=()
REMASTER_TAR_SPECS=()
REMASTER_TAR_SPECS_TAR=()
# ISO TAG is instead used as part of the images push
# to our mirror. It is always "DAILY" but it gets a special
# meaning for monthly releases.
ISO_TAG="DAILY"
OLD_ISO_TAG=""  # used to remove OLD ISO images the local dir
DISTRO_NAME="Sabayon_Linux"
ISO_DIR="daily"
DAILY_TMPDIR=
PULL_SKIP=0
EXPORT_SKIP=0
BUILD_STARTED=0

# We set our own stuff, do not inherit from env
unset PORTDIR PORTAGE_TMPDIR

# Path to molecules.git dir
SABAYON_MOLECULE_HOME="${SABAYON_MOLECULE_HOME:-/sabayon}"
export SABAYON_MOLECULE_HOME

# setup default language, cron might not do that
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# Set variable for equo command
export ETP_NONINTERACTIVE=1

# Use /var/cache/molecule instead of /var/tmp
# Because systemd may decide to reap it.
# Molecule supports MOLECULE_TMPDIR
export MOLECULE_TMPDIR="${MOLECULE_TMPDIR:-/var/cache/molecule}"

# Sabayon Server Stuff
SABAYON_DOCKER_SRC_IMAGE=${SABAYON_DOCKER_SRC_IMAGE:-sabayon/spinbase-amd64:latest}
SABAYON_UNDOCKER_OUTPUTDIR=${SABAYON_UNDOCKER_OUTPUTDIR:-${SABAYON_MOLECULE_HOME}/sources/amd64-docker-spinbase}
# Custom options
SABAYON_KERNEL_VERSION=${SABAYON_KERNEL_VERSION:-4.20}


export SABAYON_KERNEL_VERSION

build_info () {

  echo "
PULL_SKIP                  = ${PULL_SKIP}
EXPORT_SKIP                = ${EXPORT_SKIP}
SKIP_DEV                   = ${SKIP_DEV}
SKIP_DOCKER_RMI            = ${SKIP_DOCKER_RMI}
ONLY_DEV                   = ${ONLY_DEV}
LIST_IMAGES                = ${LIST_IMAGES[@]}
SABAYON_KERNEL_VERSION     = ${SABAYON_KERNEL_VERSION}
SABAYON_SERVER             = ${SABAYON_SERVER}
SABAYON_SERVER_DIR         = ${SABAYON_SERVER_DIR}
SABAYON_RSYNC_SERVER       = ${SABAYON_RSYNC_SERVER}
SABAYON_DOCKER_SRC_IMAGE   = ${SABAYON_DOCKER_SRC_IMAGE}
SABAYON_UNDOCKER_OUTPUTDIR = ${SABAYON_UNDOCKER_OUTPUTDIR}
SABAYON_EXTRA_PKGS         = ${SABAYON_EXTRA_PKGS}
MOLECULE_TMPDIR            = ${MOLECULE_TMPDIR}
SABAYON_ENMAN_REPOS        = ${SABAYON_ENMAN_REPOS}
SABAYON_SOURCE_ISO         = ${SABAYON_SOURCE_ISO}
SABAYON_SOURCE_ISO_DEV     = ${SABAYON_SOURCE_ISO_DEV}


"

}

get_iso_name () {
  local image=$1

  if [ ${image} == "spinbase" ] ; then
    echo "SpinBase"
  elif  [ ${image} == "gnome" ] ; then
    echo "GNOME"
  elif [ ${image} == "kde" ] ; then
    echo "KDE"
  elif [ ${image} == "mate" ] ; then
    echo "MATE"
  elif [ ${image} == "xfce" ] ; then
    echo "Xfce"
  elif [ ${image} == "minimal" ] ; then
    echo "Minimal"
  elif [ ${image} == "server" ] ; then
    echo "Server"
  elif [ ${image} == "lxqt" ] ; then
    echo "LXQt"
  elif [ ${image} == "gnome-forensics" ] ; then
    echo "ForensicsGnome"
  fi
}

# return 0 if spinbase is not in list
# return 1 if spinbase is in list
has_spinbase () {
  local ans=0
  local image=""

  for i in ${!LIST_IMAGES[@]}; do
    image=${LIST_IMAGES[$i]}
    if [ ${image} == "spinbase" ] ; then
      ans=1
      break
    fi
  done

  return $ans
}

prepare_specs_tasks () {
  local isoname=""
  local image=""

  for i in ${!LIST_IMAGES[@]}; do

    image=${LIST_IMAGES[$i]}

    if [ ${image} == "tarball" ] ; then
      REMASTER_TAR_SPECS+=( "sabayon-amd64-spinbase-tarball-template.spec" )
      REMASTER_TAR_SPECS_TAR+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_tarball.tar.gz" )
    elif [ ${image} == "spinbase" ] ; then

      isoname=$(get_iso_name ${LIST_IMAGES[$i]})
      if [ ${ONLY_DEV} -eq 0 ] ; then
        SOURCE_SPECS+=( "sabayon-amd64-${LIST_IMAGES[$i]}.spec" )
        SOURCE_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_${isoname}.iso" )
      fi

      if [ ${SKIP_DEV} -eq 0 ] ; then
        SOURCE_SPECS+=( "sabayon-amd64-${LIST_IMAGES[$i]}-dev.spec" )
        SOURCE_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_${isoname}-dev.iso" )
      fi

    else
      isoname=$(get_iso_name ${LIST_IMAGES[$i]})
      if [ ${ONLY_DEV} -eq 0 ] ; then
        REMASTER_SPECS+=( "sabayon-amd64-${LIST_IMAGES[$i]}.spec" )
        REMASTER_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_${isoname}.iso" )
      fi

      if [ ${SKIP_DEV} -eq 0 ] ; then
        REMASTER_SPECS+=( "sabayon-amd64-${LIST_IMAGES[$i]}-dev.spec" )
        REMASTER_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_${isoname}-dev.iso" )
      fi
    fi

  done
}

prepare_env () {

  local daily_release="$(date -u +%Y%m%d)"

  if [ ${CUSTOM_IMAGES} -eq 0 ] ; then
    if [ "${ACTION}" == "dailybase" ] ; then
      LIST_IMAGES+=(
        "spinbase"
      )
    else
      LIST_IMAGES+=(
        "spinbase"
        "gnome"
        "kde"
        "mate"
        "xfce"
        "minimal"
        "server"
        "lxqt"
        "tarball"
      )
    fi
  fi

  #############################################################
  # ACTION: weekly / daily
  #############################################################
  if [ "${ACTION}" = "weekly" ] || [ "${ACTION}" = "daily" ]; then
    SABAYON_RELEASE=${daily_release}
    export BUILDING_DAILY=1

    prepare_specs_tasks

    # Weekly molecules
    if [ "${ACTION}" = "weekly" ]; then
      REMASTER_SPECS+=( "sabayon-amd64-gnome-forensics.spec" )
      REMASTER_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_ForensicsGnome.iso" )
    fi

  #############################################################
  # ACTION: dailybase
  #############################################################
  elif [ "${ACTION}" = "dailybase" ] ; then

    SABAYON_RELEASE=${daily_release}
    export BUILDING_DAILY=1

    local i=0
    isoname=$(get_iso_name ${LIST_IMAGES[$i]})
    if [ ${ONLY_DEV} -eq 0 ] ; then
      SOURCE_SPECS+=( "sabayon-amd64-${LIST_IMAGES[$i]}.spec" )
      SOURCE_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_${isoname}.iso" )
    fi

    if [ ${SKIP_DEV} -eq 0 ] ; then
      SOURCE_SPECS+=( "sabayon-amd64-${LIST_IMAGES[$i]}-dev.spec" )
      SOURCE_SPECS_ISO+=( "${DISTRO_NAME}_${ISO_TAG}_amd64_${isoname}-dev.iso" )
    fi

  #############################################################
  # ACTION: monthly / release
  #############################################################
  elif [ "${ACTION}" = "monthly" ] || [ "${ACTION}" = "release" ]; then
    if [ "${ACTION}" = "monthly" ] && [ -z "${SABAYON_RELEASE}" ]; then

      # always one month ahead
      SABAYON_RELEASE=$(/bin/date -u --date="$(/bin/date -u +%Y-%m-%d) +1 month" "+%y.%m")

    fi

    if [ -z "${SABAYON_RELEASE}" ]; then  # release action must set this
      echo "SABAYON_RELEASE is not set, wtf?" >&2
      exit 1
    fi

    # Rewrite ISO_TAG to SABAYON_RELEASE
    ISO_TAG="${SABAYON_RELEASE}"
    if [ "${ACTION}" = "monthly" ]; then
      OLD_ISO_TAG=$(date -u --date="last month" +%y.%m)
      if [ -z "${OLD_ISO_TAG}" ]; then
        echo "Cannot set OLD_ISO_TAG, wtf?" >&2
        exit 1
      fi
    fi
    ISO_DIR="monthly"
    _previous_month=$(date -d "- 1 month" "+%Y-%m-%d")
    _current_month=$(date +%Y-%m-%d)

    # Force skipping of dev ISO for monthly/release ISO.
    SKIP_DEV=1

    prepare_specs_tasks

  fi

  # Set SABAYON_SOURCE_ISO and SABAYON_SOURCE_ISO_DEV for remaster iso images
  SABAYON_SOURCE_ISO=${SABAYON_SOURCE_ISO:-Sabayon_Linux_${ISO_TAG:-LATEST}_amd64_SpinBase.iso}
  SABAYON_SOURCE_ISO_DEV=${SABAYON_SOURCE_ISO_DEV:-Sabayon_Linux_${ISO_TAG:-LATEST}_amd64_SpinBase-dev.iso}

  # molecules are referencing ISO_TAG in their source_iso parameter
  export ISO_TAG
  # to make ISO remaster spec files working (pre_iso_script) and
  # make molecules grab a proper release version
  export SABAYON_RELEASE

  export SABAYON_SOURCE_ISO SABAYON_SOURCE_ISO_DEV

  mkdir -p "${MOLECULE_TMPDIR}" || exit 1
  mkdir -p ${SABAYON_MOLECULE_HOME}/iso || exit 1
}

cleanup_on_exit() {
  if [ "$BUILD_STARTED" = 1 ] ; then
    if [ -n "${DAILY_TMPDIR}" ] && [ -d "${DAILY_TMPDIR}" ]; then
      #rm -rf "${DAILY_TMPDIR}"
      # don't care about races
      DAILY_TMPDIR=""
    fi

    local file=""
    local has_spinbase=0
    has_spinbase || has_spinbase=1

    if [ ${has_spinbase} -eq 0 ] ; then
      echo "Cleaning Spinbase ISOs..."

      file=${SABAYON_MOLECULE_HOME}/iso/${SABAYON_SOURCE_ISO}
      rm ${file} ${file}.md5 ${file}.pkglist
      file=${SABAYON_MOLECULE_HOME}/iso/${SABAYON_SOURCE_ISO_DEV}
      rm ${file} ${file}.md5 ${file}.pkglist
    else
      echo "Leave Spinbase ISOs...."
    fi
  fi
}

docker_clean() {

  # Best effort - cleaning orphaned containers
  docker ps -a -q | xargs -n 1 -I {} sudo docker rm {}

  # Best effort - cleaning orphaned images
  local images=$(docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)
  if [ -n "${images}" ]; then
    docker rmi ${images}
  fi

}

update_docker_companion() {

   local HOST_ARCH="amd64"

   if [[ ! `which docker-companion 2>/dev/null` ]] ; then
     [[ `which ./docker-companion 2>/dev/null` ]] || {
       echo >&2 "Fetching docker-companion for you..."
       curl -s https://api.github.com/repos/mudler/docker-companion/releases/latest \
         | grep "browser_download_url.*${HOST_ARCH}" \
         | cut -d : -f 2,3 \
         | tr -d \" \
         | wget -i - -N -O docker-companion
       chmod +x docker-companion
     }
   fi
}

update_img() {
  local HOST_ARCH="amd64"
  local IMG_VERSION="0.4.8"
  local IMG_URL="https://github.com/genuinetools/img/releases/download/v${IMG_VERSION}/img-linux-${HOST_ARCH}"
  local IMG_SHA256="d8495994d46ee40180fbd3d3f13f12c81352b08af32cd2a3361db3f1d5503fa2"

   if [[ ! `which img 2>/dev/null` ]] ; then
     [[ `which ./img 2>/dev/null`  ]] || {

       echo >&2 "Fetching img ..."
       curl -fSL "${IMG_URL}" -o "./img" \
       && echo "${IMG_SHA256}  ./img" | sha256sum -c - \
       && chmod a+x "./img"
     }
  fi
}

export_docker_rootfs () {

  local docker_image=${1-${SABAYON_DOCKER_SRC_IMAGE}}
  local undocker_output_directory=${2-${SABAYON_UNDOCKER_OUTPUTDIR}}
  local opts=""

  if [[ -z "${PULL_SKIP}"  ||  "${PULL_SKIP}" == "0" ]] ; then
    opts="--pull"
  fi

  echo "Checking if Docker is available, otherwise restarting it"
  systemctl show --property ActiveState docker | \
    grep -q inactive && systemctl start docker

  echo "Building Spinbase with Docker image: "${docker_image}

  # Cleaning previous generation
  if [ -z "${undocker_output_directory}" ] || [ -z "${SABAYON_MOLECULE_HOME}" ]; then
    echo "SABAYON_MOLECULE_HOME or undocker_output_directory not set, this is bad"
    return 1
  fi
  rm -rf "${undocker_output_directory}"


  local targetdir=${undocker_output_directory}
  echo "Exporting the Docker image ${docker_image} in: " ${targetdir}

  # Unpack the image
  [ `which docker-companion 2> /dev/null` ] \
    && docker-companion ${opts} download "${docker_image}" ${targetdir} \
    || ./docker-companion ${opts} download "${docker_image}" ${targetdir}

  if [ $? -ne 0 ] ; then
    return 1
  fi

  if [ ! -e "${undocker_output_directory}/dev/urandom" ]; then
    echo "/dev/urandom not present on unpacked chroot. creating it "
    mknod -m 444 "${undocker_output_directory}"/dev/urandom c 1 9 || return 1
  fi

  if [ ${SKIP_DOCKER_RMI} -eq 1 ] ; then
    docker_clean
  fi

  return 0
}

export_img_rootfs () {
  local docker_image=${1-${SABAYON_DOCKER_SRC_IMAGE}}
  local undocker_output_directory=${2-${SABAYON_UNDOCKER_OUTPUTDIR}}

  # Cleaning previous generation
  if [ -z "${undocker_output_directory}" ] || [ -z "${SABAYON_MOLECULE_HOME}" ]; then
    echo "SABAYON_MOLECULE_HOME or undocker_output_directory not set, this is bad"
    return 1
  fi
  rm -rf "${undocker_output_directory}"

  echo "Export ${docker_image} with img to ${undocker_output_directory}..."

  [ `which img 2> /dev/null` ] \
    && img unpack ${docker_image} -o ${undocker_output_directory} \
    || ./img unpack ${docker_image} -o ${undocker_output_directory}

  if [ $? -ne 0 ] ; then
    return 1
  fi

  if [ ! -e "${undocker_output_directory}/dev/urandom" ]; then
    echo "/dev/urandom not present on unpacked chroot. creating it "
    mknod -m 444 "${undocker_output_directory}"/dev/urandom c 1 9 || return 1
  fi

  return 0
}

build_sabayon() {

  DAILY_TMPDIR=$(mktemp -d --suffix=.iso_build.sh --tmpdir=/tmp)

  echo "DAILY_TMPDIR = ${DAILY_TMPDIR}"

  [[ -z "${DAILY_TMPDIR}" ]] && return 1
  DAILY_TMPDIR_REMASTER="${DAILY_TMPDIR}/remaster"
  mkdir "${DAILY_TMPDIR_REMASTER}" || return 1

  has_spinbase
  local has_spinbase=$?
  if [ ${has_spinbase} -eq 1 ] ; then
    if [ ${EXPORT_SKIP} -eq 0 ] ; then
      export_docker_rootfs || return 1
    fi
  fi

  local scripts_dir="${SABAYON_MOLECULE_HOME}/scripts"
  local inner_chroot="${scripts_dir}/inner_source_chroot_update.sh"

  local source_specs=()
  for i in ${!SOURCE_SPECS[@]}; do
    src="${SABAYON_MOLECULE_HOME}/molecules/${SOURCE_SPECS[i]}"
    dst="${DAILY_TMPDIR}/${SOURCE_SPECS[i]}"
    cp "${src}" "${dst}" -p || return 1
    echo >> "${dst}"
    echo "inner_source_chroot_script: ${inner_chroot}" >> "${dst}"

    # tweak iso image name
    sed -i "s/destination_iso_image_name:.*/destination_iso_image_name: ${SOURCE_SPECS_ISO[i]}/" \
      "${dst}" || return 1

    echo -n "${dst}: iso: ${SOURCE_SPECS_ISO[i]} "
    echo "release: ${SABAYON_RELEASE}"
    source_specs+=( "${dst}" )
  done

  local remaster_specs=()
  for i in ${!REMASTER_SPECS[@]}; do
    src="${SABAYON_MOLECULE_HOME}/molecules/${REMASTER_SPECS[i]}"
    dst="${DAILY_TMPDIR_REMASTER}/${REMASTER_SPECS[i]}"
    cp "${src}" "${dst}" -p || return 1

    # tweak iso image name
    sed -i "s/destination_iso_image_name:.*/destination_iso_image_name: ${REMASTER_SPECS_ISO[i]}/" \
      "${dst}" || return 1

    echo -n "${dst}: iso: ${REMASTER_SPECS_ISO[i]} "
    echo "release: ${SABAYON_RELEASE}"
    remaster_specs+=( "${dst}" )
  done

  for i in ${!REMASTER_TAR_SPECS[@]}; do
    src="${SABAYON_MOLECULE_HOME}/molecules/${REMASTER_TAR_SPECS[i]}"
    dst="${DAILY_TMPDIR_REMASTER}/${REMASTER_TAR_SPECS[i]}"
    cp "${src}" "${dst}" -p || return 1

    # tweak tar name
    sed -i "s/tar_name:.*/tar_name: ${REMASTER_TAR_SPECS_TAR[i]}/" "${dst}" || return 1

    echo -n "${dst}: tar: ${REMASTER_TAR_SPECS_TAR[i]} "
    echo "release: ${SABAYON_RELEASE}"
    remaster_specs+=( "${dst}" )
  done

  local done_images=0
  local done_iso=0
  local done_something=0

  if [ ${#source_specs[@]} != 0 ]; then
    (
    flock --timeout $((24 * 3600)) -x 9
    if [ "${?}" != "0" ]; then
      echo "Timed out during source_specs lock contention" >&2
      exit 1
    fi
    molecule --nocolor "${source_specs[@]}" || exit 1
    ) 9> /tmp/.iso_build.sh.source_specs.lock || return 1
    done_something=1
    done_iso=1
  fi
  if [ ${#remaster_specs[@]} != 0 ]; then
    molecule --nocolor "${remaster_specs[@]}" || return 1
    done_something=1
    done_iso=1
  fi

  # package phases keep loading dbus, let's kill pids back
  ps ax | grep -- "/usr/bin/dbus-daemon --fork .* --session" | \
    awk '{ print $1 }' | xargs kill 2> /dev/null

  return 0
}

main () {

  parse_args () {

    help_message() {

      local script=$0

      echo "
Sabayon ISO Image Build Script.

$0 [action] [opts]

Valid actions: daily, weekly, monthly, dailybase, release.

Available options:

-h|--help               This message.
--pull-skip             Skip pull of docker image
--skip-dev              Skip build of development images (with limbo repository).
--skip-export           For development avoid export of docker image if it is already
                        present.
--docker-rmi            Enable clean of orphaned Docker images.
--only-dev              Build only development images.
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
                        Default to ${SABAYON_DOCKER_SRC_IMAGE}
SABAYON_UNDOCKER_OUTPUTDIR
                        Default to ${SABAYON_UNDOCKER_OUTPUTDIR}.
MOLECULE_TMPDIR         Default to ${MOLECULE_TMPDIR}
SABAYON_MOLECULE_HOME   Default to ${SABAYON_MOLECULE_HOME}
SABAYON_KERNEL_VERSION  Set kernel slot to install on image.
                        Default is ${SABAYON_KERNEL_VERSION}
SABAYON_EXTRA_PKGS      Define additional packages to install
                        on spinbase rootfs.
SABAYON_SOURCE_ISO      Define source ISO to remove from iso directory.
SABAYON_SOURCE_ISO_DEV  Define source ISO-dev to remoe from iso directory.
SABAYON_UNMASK_PKGS     Define additional packages to unmask.
SABAYON_MASK_PKGS       Define additional packages to mask.
SABAYON_ENMAN_REPOS     Define additional enman repository to install
                        on spinbase rootfs.

"
      return 0

    }

    local short_opts="h"
    local long_opts="help"
    long_opts="${long_opts} skip-dev image: pull-skip skip-export"
    long_opts="${long_opts} only-dev docker-rmi"
    local action=$1
    local valid_actions=(
      "daily"
      "weekly"
      "monthly"
      "dailybase"
      "release"
    )
    local valid_images=(
      "spinbase"
      "gnome"
      "kde"
      "mate"
      "minimal"
      "xfce"
      "lxqt"
      "server"
      "gnome-forensics"
      "tarball"
    )

    if [ $# -eq 0 ] ; then
      help_message
      exit 1
    fi

    ACTION="${1}"
    ACTION_VALID=
    for act in "${valid_actions[@]}"; do
      if [ "${act}" = "${ACTION}" ]; then
        ACTION_VALID=1
        break
      fi
    done
    if [ -z "${ACTION_VALID}" ]; then
      echo "invalid action: ${ACTION}" >&2
      exit 1
    fi
    shift

    $(set -- $(getopt -u -q -a -o "$short_opts" -l "$long_opts" -- "$@"))

    MAKE_TORRENTS=0
    SKIP_DEV=0
    SKIP_DOCKER_RMI=1
    ONLY_DEV=0
    IMAGE_VALID=0
    CUSTOM_IMAGES=0
    LIST_IMAGES=()

    while [ $# -gt 0 ] ; do
      case "$1" in

        -h|--help)
          help_message
          exit 1
          ;;
        --skip-dev)
          SKIP_DEV=1
          ;;
        --only-dev)
          ONLY_DEV=1
          ;;
        --skip-export)
          EXPORT_SKIP=1
          ;;
        --pull-skip)
          PULL_SKIP=1
          ;;
        --docker-rmi)
          SKIP_DOCKER_RMI=0
          ;;
        --image)
          for img in "${valid_images[@]}"; do
            if [ "${img}" = "$2" ]; then
              IMAGE_VALID=1
              break
            fi
          done
          if [ ${IMAGE_VALID} -eq 0 ]; then
            echo "invalid image: $2" >&2
            exit 1
          fi
          IMAGE_VALID=0
          CUSTOM_IMAGES=1
          LIST_IMAGES+=( $2 )
          shift
          ;;
        --)
          ;;
        *)
          echo "Invalid parameter $1."
          exit 1
          ;;

        esac

        shift
    done

    if [[ ${ONLY_DEV} -eq 1 && ${SKIP_DEV} -eq 1 ]] ; then
      echo "ERROR: Used both options --only-dev and --skip-dev at same time."
      exit 1
    fi

    unset -f help_msg

    export ACTION CUSTOM_IMAGES LIST_IMAGES ONLY_DEV
    export SKIP_DEV SKIP_DOCKER_RMI

    return 0
  }

  trap "cleanup_on_exit" EXIT INT TERM

  parse_args "$@"

  if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
  fi

  unset -f parse_args

  prepare_env

  build_info

  BUILD_STARTED=1

  has_spinbase
  local has_spinbase=$?

  if [ ${has_spinbase} -eq 1 ] ; then
    update_docker_companion
  fi

  echo "READY for build..."

  local out=0

  build_sabayon || out=1

  echo "EXIT_STATUS: ${out}"

  exit ${out}
}


main "$@"

