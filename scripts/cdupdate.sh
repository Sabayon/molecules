#!/bin/sh

CDROOT=/mnt/cdrom

CHECK_DISC=$(cat /proc/cmdline | grep checkdisc)
if [ -n "${CHECK_DISC}" ]; then
	echo "Checking Live System Image for defects..."
	cd "${CDROOT}" || exit 1
	all_fine=1
	for shafile in $(find "${CDROOT}" -name "*.sha256"); do
		target_file="${shafile/.sha256}"
		echo -en "Checking ${target_file} ... "
		target_sha=$(sha256sum "${target_file}" 2> /dev/null | cut -d" " -f 1)
		shafile_sha=$(cat "${shafile}" | cut -d" " -f 1)
		if [ "${target_sha}" != "${shafile_sha}" ]; then
			echo
			echo "target = ${target_sha}"
			echo "expect = ${shafile_sha}"
			echo
			echo "ATTENTION ATTENTION ATTENTION"
			echo "This Live System won't properly work"
			echo "Your DVD, USB stick or ISO image is damaged"
			echo "ATTENTION ATTENTION ATTENTION"
			all_fine=0
			break
		else
			echo "OK"
		fi
	done
	echo
	if [ "${all_fine}" = "1" ]; then
		echo "All fine baby, the Live System is healthy"
	else
		echo "Ouch... I am very sorry!"
	fi
	echo "Press Enter key (yeah, that one) to reboot"
	read
	reboot -f
fi
