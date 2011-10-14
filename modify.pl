#!/usr/bin/env perl
use warnings;
use strict;
use 5.010;
use Fcntl ':flock';
use Getopt::Long;

# A simple script to insert data to particle/molecule file.
# Sławomir Nizio <slawomir.nizio<at>sabayon.org>

my $tmp_file = "/tmp/add-data.temp";
my $lock_file = "/tmp/add-data.lock";

my %opts = (
	force_on_unsorted => 0,
	sort => 0,
	noask => 0,
	help => 0,
	delete => 0,
	section => undef
);

# common sections
my %sections = (
	common   => 'packages_to_add:',
	particle => 'packages:'
);

my $text_to_input;
my $file;
my $section;

my $warn_on_unsorted = 1; # true; warn only once
my @section_strings;

##### options ######
exit 1 unless
	GetOptions (
		help => \$opts{help}, sort => \$opts{sort},
		force => \$opts{force_on_unsorted}, noask => \$opts{noask},
		'section=s' => \$opts{section}, delete => \$opts{delete}
);
if ($opts{help}) {
	say "usage examples:\n\t$0 kde.common dev-util/geany";
	say "\t$0 --sort kde.common dev-util/geany";
	say "\t$0 --sort kde.common";
	say "\t$0 --delete kde.common x11-terms/xterm";
	say "--sort - sort entries";
	say "--force - don't abort if entries aren't sorted (default for --delete)";
	say "--noask - don't ask for confirmation";
	say "--delete - delete instead of adding";
	say "--section - provide own \"section\" to update, for example: ",
		'"packages_to_remove:" (note the colon)';
	exit 0;
}
$file = shift;
$text_to_input = shift;
if (not defined $file or $file !~ /\S/ or
	  (not $opts{sort}) and (not defined $text_to_input or $text_to_input !~ /\S/)) {
	die "no arg(s)... try --help\n";
}
if ($opts{delete} and (not defined $text_to_input or $text_to_input !~ /\S/)) {
	die "keyword is required when --delete used even with --sort\n";
}
if (defined $opts{section}) {
	$section = $opts{section}
} else {
	my $ext;
	my $tmp = rindex ($file, ".");
	$ext = substr ($file, $tmp+1);
	if ($sections{$ext}) {
		$section = $sections{$ext}
	}
	else {
		die "unknown extension, specify --section (and see --help)\n";
	}
}
####################

open my $fh_lock, '>', $lock_file or die "cannot open lock file\n";
flock($fh_lock, LOCK_EX | LOCK_NB) or die ("Cannot lock file!\n");
open my $fh, '<', $file or die "cannot open file $file: $!\n";
open my $fh_out, '>', $tmp_file or die "cannot open temp. file\n";

my $in_section = 0;
my $indent = "\t";
my $line_after;

while (my $line = <$fh>) {
	chomp $line;
	if ($in_section) {
		if ($line =~ /^(\s+)(\S+)$/) {
			$indent = $1;
			my $cur_section_line = $2;
			push @section_strings, $cur_section_line;
		}
		# end of "section"
		elsif ($line =~ /^\s*$/) {
			$line_after = $line;
			last;
		}
		# malformed line
		else {
			say "Section $section is not ended correctly.";
			say "Current line: $line.";
			abort();
		}
	}
	else {
		say $fh_out $line;
		# if ($line eq $section) {
		if ($line =~ /^\Q$section\E(\s*)/) {
			say "*   in section $line ($file)";
			say "    warning, trailing whitespace after section name" if ($1);
			$in_section = 1;
		}
	}
}

unless ($in_section) {
	abort ("Section $section not found in the file $file.");
}

my $ret = $opts{delete} ? delete_elem() : insert_elem();

unless ($ret) {
	# no change made
	close $fh;
	close $fh_out;
	close $fh_lock;
	exit 0;
}

write_strings ($indent, @section_strings);
say $fh_out $line_after if defined $line_after;

# now continue to end of the file
while (my $line = <$fh>) {
	print $fh_out $line;
}

if ($opts{noask}) {
	unless (rename $tmp_file, $file) {
		warn "moving file failed: $!\n";
		exit 1;
	}
	say "Wrote to $file.";
	exit 0;
}
else {
	show_diff($file, $tmp_file);
	say "OK to proceed? [y/n]";
	while (my $inp = <STDIN>) {
		chomp $inp;
		given (lc($inp)) {
			when ('y') {
				unless (rename $tmp_file, $file) {
					warn "moving file failed: $!\n";
					exit 1;
				}
				say "Wrote to $file.";
				exit 0;
			}
			when ('n') {
				say "Okay, not saving changes.";
				unlink $tmp_file or warn "removing temp. file failed: $!\n";
				unlink $lock_file or warn "removing lock file failed: $!\n";
				exit 0;
			}
			default {
				say "I don't can not understand the answer!";
			}
		}
	}
}

# Close them here due to the lock.
close $fh;
close $fh_out;
close $fh_lock;

# returns 1 if inserted anything and 0 otherwise
sub insert_elem {
	# check if it's not there already is not --sort only
	if (defined $text_to_input) {
		my $dup = search_dups ($text_to_input, 1);
		if ($dup) {
			say "Entry $text_to_input is already in the file.";
			return 0;
		}
	}

	if ($opts{sort}) {
		# $text_to_input doesn't need to be defined - provide --sort without
		# adding anything
		unshift @section_strings, $text_to_input . "," if defined $text_to_input;
		sort_elem();
		return 1;
	}
	else {
		# No --sort, $text_to_sort is always defined.
		my $prev_line;
		my $line;
		my $done = 0;
		if (@section_strings == 0) {
			push @section_strings, $text_to_input;
			return 1;
		}

		for (0..$#section_strings) {
			$line = $section_strings[$_];
			if ($prev_line and $prev_line gt $line) {
				if ($warn_on_unsorted) {
					say "The file is not sorted well! (Use --force to override.)";
					say "previous:\t$prev_line";
					say "current:\t$line";
				}
				abort() unless ($opts{force_on_unsorted});
				if ($warn_on_unsorted) {
					say "Ignoring such warnings from now.";
				}
				$warn_on_unsorted = 0;
			}
			if ($line gt $text_to_input) {
				# insert
				$text_to_input .= ",";
				splice @section_strings, $_, 0, $text_to_input;
				$done = 1;
				last;
			}
			$prev_line = $line;
		}
		# insert as last element
		unless ($done) {
			$section_strings[-1] .= ",";
			push @section_strings, $text_to_input;
		}
	}
	return 1;
}

# returns 1 if deleted anything and 0 otherwise
sub delete_elem {
	my @dups = search_dups ($text_to_input);
	unless (@dups) {
		say "Entry $text_to_input not present, nothing to delete.";
		return 0;
	}

	for my $del (@dups) {
		if ($del == $#section_strings and @section_strings > 1) {
			chop ($section_strings[-2]) if $section_strings[-2] =~ /,$/;
		}
		splice @section_strings, $del, 1;
	}
	if ($opts{sort}) {
		sort_elem();
		# cannot simply check if array before and after is the same and return 0
		# because it happens to fix indentation too (using $indent)
	}
	return 1;
}

# search for duplicated entries, return their indexes
sub search_dups {
	my $text = shift;
	die "no arg to search_dups" unless defined $text;
	my $text_c = $text . ",";
	my $stop_at_first = shift;
	my @ret = ();
	for (0..$#section_strings) {
		if ($section_strings[$_] ~~ [ $text, $text_c ]) {
			push @ret, $_;
			last if $stop_at_first;
		}
	}
	@ret;
}

# sort items (modify array in place), handle commas
sub sort_elem {
	return if @section_strings == 0;
	# to have commas where they need to be after sorting
	$section_strings[-1] .= "," unless $section_strings[-1] =~ /,$/;
	@section_strings = sort @section_strings;
	chop ($section_strings[-1]) if $section_strings[-1] =~ /,$/;
}

# write "section" strings only
sub write_strings {
	my ($indent, @strings) = @_;
	say $fh_out $indent . $_ for @strings;
}

sub show_diff {
	my ($file1, $file2) = @_;
	system ("diff", "-u", $file1, $file2);
}

sub abort {
	my $ohnoes = shift // "Aborting.";
	say $ohnoes;
	close $fh;
	close $fh_out;
	unlink $tmp_file or warn "removing temp. file failed: $!\n";
	unlink $lock_file or warn "removing lock file failed: $!\n";
	close $fh_lock;
	exit 1;
}

