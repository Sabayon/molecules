#!/bin/bash
# Author: Geaaru <geaaru@sabayonlinux.org>

SAB_GENHTML_SCRIPTDIR=${0%/*}
SAB_GENHTML_SCRIPT_TEMPL=${SAB_GENHTML_SCRIPT_TEMPL:-${SAB_GENHTML_SCRIPTDIR}/templ+abc.pl}
SAB_GENHTML_COMMONS_ARGS="${SAB_GENHTML_COMMONS_ARGS:---skip .. --skip main.html --skip monthly.html --skip style.css}"
SAB_GENHTML_DUMP_HTML=${SAB_GENHTML_DUMP_HTML:-0}
SAB_GENHTML_REMOVE_ISO=${SAB_GENHTML_REMOVE_ISO:-0}

error () {
  echo "$1"
  exit 1
}

help_message () {

  echo "
-----------------------------------
Sabayon ISO HTML Generator Pages
-----------------------------------

[--help|-h]               Show this message.
[--dir <isodir>]          Directory where found ISO
[--type <monthly|daily>]  Type of HTML pages to create. Default daily.
[--target <dir>]          Target dir where copy HTML pages.
                          Default is same <isodir> path.
"

  exit 0
}

parse_args () {
  local short_opts="h"
  local long_opts="help dir: type:"

  $(set -- $(getopt -u -q -a -o "$short_options" -l "$long_options" -- "$@")) || \
    error "Invalid parameters"

  SAB_GENHTML_TYPE="daily"
  SAB_GENHTML_DIR=""
  SAB_GENHTML_TARGET=""

  if [ $# -lt 1 ] ; then
    help_message
  fi

  while [ $# -gt 0 ] ; do
    case "$1" in
      -h|--help)
        help_message
        ;;
      --type)
        SAB_GENHTML_TYPE=$2
        shift
        ;;
      --dir)
        SAB_GENHTML_DIR=$2
        shift
        ;;
      --target)
        SAB_GENHTML_TARGET=$2
        shift
        ;;
      *)
        error "Unexpected option $1"
        ;;
    esac
    shift
  done

  if [ -z "$SAB_GENHTML_TYPE" ] ; then
    SAB_GENHTML_TYPE="daily"
  else
    if [[ $SAB_GENHTML_TYPE != "daily" && $SAB_GENHTML_TYPE != "monthly" ]] ; then
      error "Invalid type! Use daily or monthly."
    fi
  fi

  if [ -z "$SAB_GENHTML_DIR" ] ; then
    error "ISO directory parameter not set"
  fi

  if [ -z "$SAB_GENHTML_TARGET" ] ; then
    SAB_GENHTML_TARGET=$SAB_GENHTML_DIR
  fi
}

main () {

  parse_args "$@"

  SAB_GENHTML_TMPOUTPUT=$(mktemp -t ${SAB_GENHTML_TYPE}-XXXXXX.html)
  export SAB_GENHTML_TMPOUTPUT

  echo "====================================================================="
  echo "Prepare to generate ${SAB_GENHTML_TYPE} pages for dir ${SAB_GENHTML_DIR}..."
  echo "====================================================================="

  if [ $SAB_GENHTML_TYPE == "daily" ] ; then
    ${SAB_GENHTML_SCRIPT_TEMPL} ${SAB_GENHTML_COMMONS_ARGS} daily \
      --template "${SAB_GENHTML_SCRIPTDIR}/daily.tmpl" \
      --dir ${SAB_GENHTML_DIR} > ${SAB_GENHTML_TMPOUTPUT} || \
        error "Error on generate HTML page"
  else
    ${SAB_GENHTML_SCRIPT_TEMPL} ${SAB_GENHTML_COMMONS_ARGS} main \
      --template "${SAB_GENHTML_SCRIPTDIR}/monthly.tmpl" \
      --dir ${SAB_GENHTML_DIR} > ${SAB_GENHTML_TMPOUTPUT} || \
        error "Error on generate HTML page"
  fi

  echo "Created correctly file ${SAB_GENHTML_TMPOUTPUT}"
  echo "====================================================================="
  if [ ${SAB_GENHTML_DUMP_HTML} -eq 1 ] ; then
    cat ${SAB_GENHTML_DUMP_HTML}
    echo "====================================================================="
  fi

  # Move generated html page to target dir
  mv ${SAB_GENHTML_TMPOUTPUT} ${SAB_GENHTML_TARGET}/${SAB_GENHTML_TYPE}.html || \
    error "Error on move file ${SAB_GENHTML_TMPOUTPUT} to ${SAB_GENHTML_TARGET}/${SAB_GENHTML_TYPE}.html"

  echo "Copy style.css file to ${SAB_GENHTML_TARGET} dir..."
  cp ${SAB_GENHTML_SCRIPTDIR}/style.css ${SAB_GENHTML_TARGET}/ || \
    error "Error on copy file style.css to ${SAB_GENHTML_TARGET} directory."

  if [ ${SAB_GENHTML_REMOVE_ISO} -eq 1 ] ; then
    # Remove ISO files from $SAB_GENHTML_TARGET recursively
    find . -name *.iso* -exec rm -if {} \;
  fi

  exit 0
}

main "$@"
