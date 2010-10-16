#!/bin/sh
 
# Simple shell-based filter. It is meant to be invoked as follows:
#       /path/to/script -f sender recipients...

#INSPECT_DIR="/var/spool/filter"
#DELIVER="/usr/libexec/dovecot/deliver"
#EMAILPUSH="/usr/local/mmt_scripts/emailpush.pl"
#SCHEDULEBE="/usr/local/mmt_scripts/schedulebe.py"
#LOGGER_FACILITY="mail"
#LOGGER_PRIORITY="info"
#LOGGER_PROGRAM_NAME="deliver.sh"

# Exit codes from <sysexits.h>
#EX_TEMPFAIL=75
#EX_UNAVAILABLE=69

source /usr/local/mmt_scripts/config.sh
if [ $? -ne 0 ]; then exit 75; fi

COMMAND=$(which echo); if [ $? -ne 0 ] || [ ! -x $COMMAND ]; then echo "echo command doesn't exist"; exit $EX_TEMPFAIL;fi
COMMAND=$(which cut); if [ $? -ne 0 ] || [ ! -x $COMMAND ]; then echo "cut command doesn't exist"; exit $EX_TEMPFAIL;fi
COMMAND=$(which cat); if [ $? -ne 0 ] || [ ! -x $COMMAND ]; then echo "cat command doesn't exist"; exit $EX_TEMPFAIL;fi
COMMAND=$(which egrep); if [ $? -ne 0 ] || [ ! -x $COMMAND ]; then echo "egrep command doesn't exist"; exit $EX_TEMPFAIL;fi
COMMAND=$(which grep); if [ $? -ne 0 ] || [ ! -x $COMMAND ]; then echo "grep command doesn't exist"; exit $EX_TEMPFAIL;fi
COMMAND=$(which logger); if [ $? -ne 0 ] || [ ! -x $COMMAND ]; then echo "logger command doesn't exist"; exit $EX_TEMPFAIL;fi

# Clean up when done or when aborting.
trap "rm -f in.$$" 0 1 2 3 15

# Start processing.
cd $INSPECT_DIR || {
    echo $INSPECT_DIR does not exist; exit $EX_TEMPFAIL; }

cat >in.$$ || { 
     echo Cannot save mail to file $UID; exit $EX_TEMPFAIL; }

LINE=$(egrep -m 1 "by.+with.+[0-9A-Fa-f]+$" in.$$)
HEX=$(echo $LINE | egrep -o " id [0-9A-Fa-f]+$" | cut -d " " -f 3)
if [ -z $HEX ]; then
	LINE=$(egrep -m 1 "id [0-9A-Fa-f]+;.+" in.$$)
	HEX=$(echo $LINE | egrep -o "id [0-9A-Fa-f]+" | cut -d " " -f 2)
fi

grep -P "^X-MW-Scheduler:\scalendar.myplace.edu$" in.$$
if [ $? -ne 0 ]; then
	#SCHEDULEBE_OUT=$(cat in.$$ | $SCHEDULEBE -U $SCHEDULEBE_URL -u $SCHEDULEBE_USERNAME -p $SCHEDULEBE_PASSWORD)
	SCHEDULEBE_OUT=$(cat in.$$ | $SCHEDULEBE -U $SCHEDULEBE_URL)
        logger -t $LOGGER_PROGRAM_NAME -p $LOGGER_FACILITY.$LOGGER_PRIORITY "mail-id $HEX - schedulebe.py: $SCHEDULEBE_OUT"
fi

#EMAILPUSH_OUT=$($EMAILPUSH "$@" -h $EMAILPUSH_HOSTNAME -p $EMAILPUSH_PORTNO -P $EMAILPUSH_PREFIX)
#logger -t $LOGGER_PROGRAM_NAME -p $LOGGER_FACILITY.$LOGGER_PRIORITY "mail-id $HEX - emailpush.sh: $EMAILPUSH_OUT"
 
DELIVER_OUT=$($DELIVER "$@" <in.$$)
DELIVER_EXIT_STATUS=$?
if [ $DELIVER_EXIT_STATUS -eq 0 ]; then
	logger -t $LOGGER_PROGRAM_NAME -p $LOGGER_FACILITY.$LOGGER_PRIORITY "mail-id $HEX - dovecot deliver: mail sent - exit status $DELIVER_EXIT_STATUS"
else
        logger -t $LOGGER_PROGRAM_NAME -p $LOGGER_FACILITY.$LOGGER_PRIORITY "mail-id $HEX - dovecot deliver: error - exit status $DELIVER_EXIT_STATUS"
fi


exit $DELIVER_EXIT_STATUS

