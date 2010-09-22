#!/bin/sh
export FORCE_EAPI=2
equo update || ( sleep 1200 && equo update ) || exit 1
