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
CHANGELOG_DATES=""
DAILY_TMPDIR=
LOG_FILE=
PULL_SKIP=0
EMAIL_SKIP=0
EXPORT_SKIP=0

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
SABAYON_SERVER="${SABAYON_SERVER:-entropy@pkg.sabayon.org}"
SABAYON_SERVER_DIR="${SABAYON_SERVER_DIR:-/sabayon/rsync}"
SABAYON_RSYNC_SERVER="${SABAYON_RSYNC_SERVER:-rsync.sabayon.org}"
SABAYON_DOCKER_SRC_IMAGE=${SABAYON_DOCKER_SRC_IMAGE:-sabayon/spinbase-amd64:latest}
SABAYON_UNDOCKER_OUTPUTDIR=${SABAYON_UNDOCKER_OUTPUTDIR:-${SABAYON_MOLECULE_HOME}/sources/amd64-docker-spinbase}
# Custom options
SABAYON_KERNEL_VERSION=${SABAYON_KERNEL_VERSION:-4.14}

export SABAYON_KERNEL_VERSION

build_info () {

  echo "
DO_PUSH                    = ${DO_PUSH}
DO_PUSHONLY                = ${DO_PUSHONLY}
DO_SLEEPNIGHT              = ${DO_SLEEPNIGHT}
EMAIL_SKIP                 = ${EMAIL_SKIP}
PULL_SKIP                  = ${PULL_SKIP}
EXPORT_SKIP                = ${EXPORT_SKIP}
SKIP_DEV                   = ${SKIP_DEV}
SKIP_DOCKER_RMI            = ${SKIP_DOCKER_RMI}
ONLY_DEV                   = ${ONLY_DEV}
LOG_FILE                   = ${LOG_FILE}
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
  fi
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
    CHANGELOG_DATES="${_previous_month} ${_current_month}"

    # Force skipping of dev ISO for monthly/release ISO.
    SKIP_DEV=1

    prepare_specs_tasks

  fi

  # molecules are referencing ISO_TAG in their source_iso parameter
  export ISO_TAG
  # to make ISO remaster spec files working (pre_iso_script) and
  # make molecules grab a proper release version
  export SABAYON_RELEASE

  if [ -z "${LOG_FILE}" ] ; then
    # Create log dir if it does not exist
    mkdir -p /var/log/molecule || exit 1

    LOG_FILE="/var/log/molecule/autobuild-${SABAYON_RELEASE}-pid-${$}-rnd-${RANDOM}.log"
  fi

  mkdir -p "${MOLECULE_TMPDIR}" || exit 1
  mkdir -p ${SABAYON_MOLECULE_HOME}/iso || exit 1

}


sleepnight() {
  if [ ${DO_SLEEPNIGHT} -eq 1 ]; then
    target_h=22 # 22pm
    current_h=$(date +%H)
    current_h=${current_h/0} # remove leading 0
    delta_h=$(( target_h - current_h ))
    if [ ${current_h} -ge 0 ] && [ ${current_h} -le 6 ]; then
      # If it's past midnight and no later than 7am
      # just push
      echo "Just pusing out now"
    elif [ ${delta_h} -gt 0 ]; then
      delta_s=$(( delta_h * 3600 ))
      echo "Sleeping for ${delta_h} hours..."
      sleep ${delta_s} || exit 1
    elif [ ${delta_h} -lt 0 ]; then
      # between 22 and 24, run!
      echo "I'm after 22pm, running"
    else
      echo "No need to sleep"
    fi
  fi
}

cleanup_on_exit() {
  if [ -n "${DAILY_TMPDIR}" ] && [ -d "${DAILY_TMPDIR}" ]; then
    #rm -rf "${DAILY_TMPDIR}"
    # don't care about races
    DAILY_TMPDIR=""
  fi
}

safe_run() {
  local done=0
  local count="${1}"
  shift

  for ((i=0; i < ${count}; i++)); do
    "${@}" && {
      done=1;
      break;
    }
    if [ ${i} -le 3 ]; then
      sleep 10 || return 1
    elif [ ${i} -le 6 ]; then
      sleep 600 || return 1
    else
      sleep 1800 || return 1
    fi
  done
  if [ "${done}" = "0" ]; then
    return 1
  fi
  return 0
}

remove_from_mirrors() {
  local path="${1}"
  local server=${SABAYON_SERVER}
  local ssh_dir=${SABAYON_SERVER_DIR}
  local ssh_path="${server}:${ssh_dir}"

  if [ -z "${path}" ]; then
    echo "remove_from_mirrors: no arguments passed" >&2
    return 1
  fi

  safe_run 10 ssh "${server}" \
    rm -f "${ssh_dir}/${SABAYON_RSYNC_SERVER}/iso/${ISO_DIR}/${path}"
}

move_to_mirrors() {
  local do_push="${SABAYON_MOLECULE_HOME}"/DO_PUSH
  local server=${SABAYON_SERVER}
  local ssh_dir=${SABAYON_SERVER_DIR}
  local ssh_path="${server}:${ssh_dir}"

  if [ ${DO_PUSH} -eq 1 ] || [ -f "${do_push}" ]; then

    sleepnight
    rm -f "${do_push}"

    (
      flock --timeout $((24 * 3600)) -x 9
      if [ "${?}" != "0" ]; then
        echo "Timed out during move_to_mirrors lock contention" >&2
        exit 1
      fi

      safe_run 10 rsync -av --partial --bwlimit=8192 \
        "${SABAYON_MOLECULE_HOME}"/iso_rsync/*"${ISO_TAG}"* \
        "${ssh_path}/${SABAYON_RSYNC_SERVER}/iso/${ISO_DIR}" \
        || exit 1

      if [ "${ACTION}" = "monthly" ]; then
        mkdir -p "${SABAYON_MOLECULE_HOME}/iso_rsync/${ISO_DIR}" || exit 1
        echo "${ISO_TAG}" > "${SABAYON_MOLECULE_HOME}/iso_rsync/${ISO_DIR}/LATEST_IS" || exit 1
        safe_run 10 rsync -av --partial \
          "${SABAYON_MOLECULE_HOME}/iso_rsync/${ISO_DIR}/LATEST_IS" \
          "${ssh_path}/${SABAYON_RSYNC_SERVER}/iso/${ISO_DIR}/" \
          || exit 1
      fi

      if [ -n "${CHANGELOG_DATES}" ]; then
        safe_run 10 rsync -av --partial \
          "${CHANGELOG_DIR}"/ \
          "${ssh_path}/${SABAYON_RSYNC_SERVER}/iso/${ISO_DIR}/ChangeLogs/"
      fi

      safe_run 10 rsync -av --partial \
        "${SABAYON_MOLECULE_HOME}"/scripts/gen_html \
        "${ssh_path}"/iso_html_generator \
        || exit 1

      safe_run 10 ssh "${server}" \
        "${ssh_dir}"/iso_html_generator/gen_html/gen.sh \
        || exit 1

      ) 9> /tmp/.iso_build.sh.move_to_mirrors.lock || return 1
      return 0
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
     [ `which ./docker-companion 2>/dev/null` ] || {
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

export_docker_rootfs () {

  local docker_image=${1-${SABAYON_DOCKER_SRC_IMAGE}}
  local undocker_output_directory=${2-${SABAYON_UNDOCKER_OUTPUTDIR}}
  local opts=""

  if [[ -z "${PULL_SKIP}"  ||  "${PULL_SKIP}" == "0" ]] ; then
    opts="--pull"
  fi

  echo "Checking if Docker is available, otherwise restarting it"
  systemctl show --property ActiveState docker | grep -q inactive && systemctl start docker

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
    && docker-companion ${opts} unpack --squash "${docker_image}" ${targetdir} \
    || ./docker-companion ${opts} unpack --squash "${docker_image}" ${targetdir}

  if [ $? -ne 0 ] ; then
    return 1
  fi

  if [ ! -e "${undocker_output_directory}/dev/urandom" ]; then
    echo "/dev/urandom not present on unpacked chroot. creating it "
    mknod -m 444 "${undocker_output_directory}"/dev/urandom c 1 9 || return 1
  fi

  if [ ${SKIP_DOCKER_RMI} -eq 0 ] ; then
    docker_clean
  fi

  return 0
}

build_sabayon() {

  DAILY_TMPDIR=$(mktemp -d --suffix=.iso_build.sh --tmpdir=/tmp)

  echo "DAILY_TMPDIR = ${DAILY_TMPDIR}"

  [[ -z "${DAILY_TMPDIR}" ]] && return 1
  DAILY_TMPDIR_REMASTER="${DAILY_TMPDIR}/remaster"
  mkdir "${DAILY_TMPDIR_REMASTER}" || return 1

  if [ ${EXPORT_SKIP} -eq 0 ] ; then
    export_docker_rootfs || return 1
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
  ps ax | grep -- "/usr/bin/dbus-daemon --fork .* --session" | awk '{ print $1 }' | xargs kill 2> /dev/null

  if [ "${done_something}" = "1" ]; then
    if [ ${MAKE_TORRENTS} -eq 1 ]; then
      flock -x /tmp/.iso_build.sh.make_torrents.lock \
        "${SABAYON_MOLECULE_HOME}"/scripts/make_torrents.sh || return 1
    fi

    if [ "${done_iso}" = "1" ]; then
      cp -p "${SABAYON_MOLECULE_HOME}"/iso/*"${ISO_TAG}"* \
        "${SABAYON_MOLECULE_HOME}"/iso_rsync/ || return 1
    fi

    date > "${SABAYON_MOLECULE_HOME}"/iso_rsync/RELEASE_DATE_"${ISO_TAG}"

    # remove old ISO images?
    if [ -n "${OLD_ISO_TAG}" ]; then
      echo "Removing old ISO images tagged ${OLD_ISO_TAG} locally"
      rm -rf "${SABAYON_MOLECULE_HOME}"/{iso,iso_rsync}/"${DISTRO_NAME}"*"${OLD_ISO_TAG}"*
      echo "Removing old ISO images tagged ${OLD_ISO_TAG} remotely"
      remove_from_mirrors "${DISTRO_NAME}*${OLD_ISO_TAG}*"
      remove_from_mirrors "RELEASE_DATE_${OLD_ISO_TAG}"
    fi

  fi

  if [ -n "${CHANGELOG_DATES}" ]; then
    flock -x /tmp/.iso_build.sh.make_git_logs.lock \
      "${SABAYON_MOLECULE_HOME}"/scripts/make_git_logs.sh \
      "${CHANGELOG_DIR}" ${CHANGELOG_DATES}
  fi

  return 0
}

mail_failure() {
  local out=${1}
  local log_file=${2}
  local log_cont=

  # get the last 64 lines of the file
  if [ -f "${log_file}" ]; then
    log_cont=$(tail -n 64 "${log_file}" 2> /dev/null)
  fi

  echo "Hello there,
iso_build.sh execution failed (miserably) with exit status: ${out}.
Log file is at: ${log_file}

Last log lines:
[... snip ...]
${log_cont}
[... snip ...]

Thanks,
Sun" | mail -s "${ACTION} images build script failure" root
}

mail_success() {
  echo "Hello there,

New ${ACTION} images tagged as ${ISO_TAG} have been built and pushed to mirrors.
http://www.sabayon.org/latest (node/306) will be updated in 24 hours automatically.

" | mail -s "Action required: ${ACTION} ${ISO_TAG} images built" root

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
--push                  Enable push to Sabayon Server
--pull-skip             Skip pull of docker image
--stdout                Print debug message to stdout
--sleepnight            Execute build after 22pm and sleep until that hour.
--pushonly              Push only images
--torrents              Make torrent files.
--changelogsdir [DIR]
                        Set changelog directory. Default is
                        \${SABAYON_MOLECULE_HOME}/\${ACTION}-git-logs.
--skip-dev              Skip build of development images (with limbo repository).
--skip-export           For development avoid export of docker image if it is already
                        present.
--skip-docker-rmi       Skip clean of orphaned Docker images.
--skip-email            Skip sent of mail.
--only-dev              Build only development images.
--logfile [PATH]        Customize logfile path.
--image [NAME]          Build only a specific image. (This option can be used multiple time).
                        Valid value are:
                          * spinbase
                          * gnome
                          * kde
                          * mate
                          * minimal
                          * xfce
                          * lxqt

Environment variables to customize:
SABAYON_SERVER          Default to ${SABAYON_SERVER}
SABAYON_SERVER_DIR      Default to ${SABAYON_SERVER_DIR}
SABAYON_RSYNC_SERVER    Default to ${SABAYON_RSYNC_SERVER}
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
SABAYON_UNMASK_PKGS     Define additional packages to unmask.
SABAYON_ENMAN_REPOS     Define additional enman repository to install
                        on spinbase rootfs.

"
      return 0

    }

    local short_opts="h"
    local long_opts="help push stdout sleepnight pushonly torrents changelogsdir:"
    long_opts="${long_opts} skip-dev image: logfile: pull-skip skip-email skip-export"
    long_opts="${long_opts} only-dev skip-docker-rmi"
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
    DO_PUSH=0
    DO_STDOUT=0
    DO_SLEEPNIGHT=0
    DO_PUSHONLY=0
    SKIP_DEV=0
    SKIP_DOCKER_RMI=0
    ONLY_DEV=0
    IMAGE_VALID=0
    CUSTOM_IMAGES=0
    LIST_IMAGES=()
    CHANGELOG_DIR="${SABAYON_MOLECULE_HOME}/${ACTION}-git-logs"

    while [ $# -gt 0 ] ; do
      case "$1" in

        -h|--help)
          help_message
          exit 1
          ;;
        --push)
          DO_PUSH=1
          ;;
        --stdout)
          DO_STDOUT=1
          ;;
        --sleepnight)
          DO_SLEEPNIGHT=1
          ;;
        --pushonly)
          DO_PUSHONLY=1
          DO_PUSH=1
          ;;
        --torrents)
          MAKE_TORRENTS=1
          ;;
        --changelogsdir)
          CHANGELOG_DIR=$2
          shift
          ;;
        --skip-dev)
          SKIP_DEV=1
          ;;
        --only-dev)
          ONLY_DEV=1
          ;;
        --skip-email)
          EMAIL_SKIP=1
          ;;
        --skip-export)
          EXPORT_SKIP=1
          ;;
        --pull-skip)
          PULL_SKIP=1
          ;;
        --skip-docker-rmi)
          SKIP_DOCKER_RMI=1
          ;;
        --logfile)
          LOG_FILE=$2
          # TODO: I can create directory if doesn't exist
          shift
          ;;
        --image)
          for im in "${valid_images[@]}"; do
            if [ "${img}" = "$2" ]; then
              IMAGE_VALID=1
              break
            fi
          done
          if [ -z "${IMAGE_VALID}" ]; then
            echo "invalid image: $2" >&2
            exit 1
          fi
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

    export ACTION DO_PUSH DO_STDOUT DO_SLEEPNIGHT DO_PUSHONLY MAKE_TORRENTS
    export CHANGELOG_DIR CUSTOM_IMAGES LIST_IMAGES ONLY_DEV SKIP_DEV SKIP_DOCKER_RMI

    return 0
  }

  parse_args "$@"

  if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
  fi

  unset -f parse_args

  prepare_env

  mkdir -p "${CHANGELOG_DIR}" || exit 1

  build_info

  trap "cleanup_on_exit" EXIT INT TERM

  update_docker_companion

  echo "READY for build..."

  local out=0
  if [ ${DO_STDOUT} -eq 1 ]; then
    if [ ${DO_PUSHONLY} -eq 0 ]; then
      build_sabayon
      out=${?}
    fi
    if [ "${out}" = "0" ]; then
      move_to_mirrors
      out=${?}
    fi
  else
    if [ ${DO_PUSHONLY} -eq 0 ]; then
      build_sabayon &> "${LOG_FILE}"
      out=${?}
    fi
    if [ "${out}" = "0" ]; then
      move_to_mirrors &>> "${LOG_FILE}"
      out=${?}
    fi

    if [ ${EMAIL_SKIP} -eq 0 ] ; then
      if [ "${out}" != "0" ]; then
        # mail root
        mail_failure "${out}" "${LOG_FILE}"
      else
        if [ "${ACTION}" = "monthly" ] || [ "${ACTION}" = "release" ]; then
          mail_success
        fi
      fi
    fi
  fi
  echo "EXIT_STATUS: ${out}"

  exit ${out}
}


main "$@"

