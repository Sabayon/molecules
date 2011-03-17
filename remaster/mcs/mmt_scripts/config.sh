#!/bin/bash

EMAILPUSH_HOSTNAME=""
EMAILPUSH_PORTNO="4242"
EMAILPUSH_PREFIX="PREFIX"

INSPECT_DIR="/var/spool/filter"
DELIVER="/usr/libexec/dovecot/deliver"
EMAILPUSH="/usr/local/mmt_scripts/emailpush.pl"
SCHEDULEBE="/usr/local/mmt_scripts/schedulebe.py"
LOGGER_FACILITY="mail"
LOGGER_PRIORITY="info"
LOGGER_PROGRAM_NAME="deliver.sh"

# Exit codes from <sysexits.h>
EX_TEMPFAIL=75
EX_UNAVAILABLE=69

SCHEDULEBE_URL="http://localhost:8080/pubcaldav/rtsvc"
SCHEDULEBE_USERNAME="caladmin"
SCHEDULEBE_PASSWORD="caladmin"
