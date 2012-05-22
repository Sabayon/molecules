#!/bin/sh

script_dir=${0%/*}

script=$script_dir/templ+abc.pl

warn() {
	echo "$*" >&2
}

if [ ! -f "$script" ]; then
	warn "error, file templ+abc.pl cannot be found in directory '$script_dir'"
	warn "(PWD=$PWD)"
	exit 2
fi

iso_dir_prefix="/sabayon/rsync/rsync.sabayon.org/iso"
main_dir=$iso_dir_prefix
dailies_dir=$iso_dir_prefix/daily
unset iso_dir_prefix

for dir in "$main_dir" "$dailies_dir"; do
	if [ ! -d "$dir" ]; then
		warn "'$dir' doesn't exist or is not a directory"
		exit 2
	fi
done

common_args="--skip .. --skip main.html --skip daily.html --skip style.css"

tmpfile="$script_dir/tmp.html"

if ! rm -f "$tmpfile"; then
	warn "rm -f $tmpfile failed!"
	exit 2
fi

# main
if ! "$script" $common_args \
		main --template "$script_dir/main.tmpl" --dir "$main_dir" \
		> "$tmpfile"; then
	warn "script for main releases failed"
	rm -f "$tmpfile"
	exit 2
fi

if ! mv "$tmpfile" "$main_dir/main.html"; then
	warn "mv $tmpfile $main_dir/main.html failed"
	rm -f "$tmpfile"
	exit 2
fi

# dailies
if ! "$script" $common_args \
		daily --template "$script_dir/daily.tmpl" --dir "$dailies_dir" \
		> "$tmpfile"; then
	warn "script for daily releases failed"
	rm -f "$tmpfile"
	exit 2
fi

if ! mv "$tmpfile" "$dailies_dir/daily.html"; then
	warn "mv $tmpfile $dailies_dir/daily.html failed"
	rm -f "$tmpfile"
	exit 2
fi

# CSS
if ! cp "$script_dir/style.css" "$main_dir/"; then
	warn "cp $script_dir/style.css $main_dir/ failed"
	exit 2
fi
