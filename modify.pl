#!/usr/bin/env perl
use warnings;
use strict;
use 5.010;
use Fcntl ':flock';
use Getopt::Long;
use File::Spec;

# A simple script to insert data to particle/molecule file.
# Sławomir Nizio <slawomir.nizio<at>sabayon.org>

my $tmp_file;
my $lock_file;

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

{
	my ($vol, $dir) = File::Spec->splitpath($file);
	$tmp_file  = File::Spec->catpath($vol, $dir, "_add-data.temp");
	$lock_file = File::Spec->catpath($vol, $dir, "_add-data.lock");
}

open my $fh_lock, '>', $lock_file or die "cannot open lock file: $!\n";
flock($fh_lock, LOCK_EX | LOCK_NB) or die ("Cannot lock file!\n");
open my $fh, '<', $file or die "cannot open file $file: $!\n";
open my $fh_out, '>', $tmp_file or die "cannot open temp. file\n";

my $parser = Parser->new;
while (my $line = <$fh>) {
	my $st = $parser->parse_line($line);
	last unless $st;
	print $fh_out $line unless $parser->in_section;
}

unless ($parser->in_section) {
	abort ("Section $section not found in the file $file.");
}

my $ret = $opts{delete} ? delete_elem() : insert_elem();

unless ($ret) {
	# no change made
	cleanup_all();
	exit 0;
}

say $fh_out $parser->line_before if defined $parser->line_before;
write_strings ($parser->indent, $parser->section_blocks);
say $fh_out $parser->line_after if defined $parser->line_after;

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
		my $lc_inp = lc $inp;

		if ($lc_inp eq 'y') {
			unless (rename $tmp_file, $file) {
				warn "moving file failed: $!\n";
				exit 1;
			}
			say "Wrote to $file.";
			unlink $lock_file or warn "removing lock file failed: $!\n";
			exit 0;
		}
		elsif ($lc_inp eq 'n') {
			say "Okay, not saving changes.";
			unlink $tmp_file or warn "removing temp. file failed: $!\n";
			unlink $lock_file or warn "removing lock file failed: $!\n";
			exit 0;
		}
		else {
			say "I can't of understand the answer not!";
		}
	}
}

# Close them here due to the lock.
close $fh;
close $fh_out;
close $fh_lock;

# returns 1 if inserted anything and 0 otherwise
sub insert_elem {
	my @section_blocks = $parser->section_blocks;

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
		if (defined $text_to_input) {
			if (@section_blocks) {
				# todo: implement more than just adding to the first block
				my $bd = $section_blocks[0];
				$bd->add($text_to_input);
			}
			else {
				$parser->add_item($text_to_input);
			}
		}

		sort_elem($parser->section_blocks);
		return 1;
	}
	else {
		# No --sort, $text_to_sort is always defined.
		my $prev_line;
		my $line;
		my $done = 0;
		if (not @section_blocks) {
			$parser->add_item($text_to_input);
			return 1;
		}

		# todo: implement more than just adding to the first block
		my $bd = $section_blocks[0];
		my @data = $bd->data;

		for (0..$#data) {
			$line = $data[$_];
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
				$bd->add($text_to_input, at => $_);
				$done = 1;
				last;
			}
			$prev_line = $line;
		}
		# insert as last element
		unless ($done) {
			$bd->add($text_to_input)
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
		my ($block, $index) = (@$del);
		$block->delete(index => $index);
	}

	$parser->normalize;

	if ($opts{sort}) {
		sort_elem($parser->section_blocks);
	}
	return 1;
}

# search for duplicated entries, return list of [section, index]
sub search_dups {
	my $text = shift;
	die "no arg to search_dups" unless defined $text;
	my $stop_at_first = shift;
	my @ret = ();

	OUTER: for my $block ($parser->section_blocks) {
		my @data = $block->data;
		for (0..$#data) {
			if ($data[$_] eq $text) {
				push @ret, [ $block, $_ ];
				last OUTER if $stop_at_first;
			}
		}
	}
	@ret;
}

# sort items (modify array in place)
sub sort_elem {
	for my $block (@_) {
		$block->sort;
	}
}

# write "section" strings only
sub write_strings {
	my ($indent, @blocks) = @_;

	for my $ind (0..$#blocks) {
		my @lines = $blocks[$ind]->data(1);
		if ($ind == $#blocks) {
			# remove comma from the last line in the last block
			$lines[-1] =~ s/,$//;
		}
		say $fh_out $indent . $_ for @lines;
		say $fh_out "";
	}
}

sub show_diff {
	my ($file1, $file2) = @_;
	system ("diff", "-u", $file1, $file2);
}

sub cleanup_all {
	close $fh;
	close $fh_out;
	unlink $tmp_file or warn "removing temp. file failed: $!\n";
	unlink $lock_file or warn "removing lock file failed: $!\n";
	close $fh_lock;
}

sub abort {
	say shift // "Aborting.";
	cleanup_all();
	exit 1;
}

package BlockData;
sub new {
	my $class = shift;
	my $squashed = shift;
	my $self = {
		squashed => $squashed
	};
	bless $self, $class;
}

sub is_squashed {
	my $self = shift;
	$self->{squashed} ? 1 : 0;
}

sub sort {
	my $self = shift;
	$self->{data} = [ sort @{$self->{data}} ];
}

sub delete {
	my $self = shift;
	my %opts = @_;
	die "wrong option" unless defined $opts{index};
	splice @{$self->{data}}, $opts{index}, 1;
}

sub data {
	my $self = shift;
	my $join_with_delimiter = shift;
	my @data = @{$self->{data}};

	if ($join_with_delimiter) {
		if ($self->is_squashed) {
			map { $_ . "," } @data
		}
		else {
			my $last = $#data;
			@data[0..$last-1], $data[-1] . ","
		}
	}
	else {
		@data
	}
}

sub add {
	my $self = shift;
	my $data = shift;
	my %opts = @_;
	if (not exists $opts{at}) {
		push @{$self->{data}}, $data;
	}
	else {
		splice @{$self->{data}}, $opts{at}, 0, $data;
	}
}

package Parser;
sub new {
	my $class = shift;
	my $self = {
		section_blocks => [],
		tmp_ungrouped_section_lines => [],
	};
	bless $self, $class;

	$self->in_section(0);
	$self->indent("\t");
	$self->line_before(undef);
	$self->line_after(undef);
	return $self;
}

sub _accessor {
	my $self = shift;
	my ($what, $new_val) = @_;
	$self->{$what} = $new_val
		if @_ > 1;
	$self->{$what};
}

sub in_section {
	my $self = shift;
	$self->_accessor("section", @_)
}

sub indent {
	my $self = shift;
	$self->_accessor("indent", @_)
}

sub line_before {
	my $self = shift;
	$self->_accessor("line_before", @_)
}

sub line_after {
	my $self = shift;
	$self->_accessor("line_after", @_)
}

sub section_blocks {
	my $self = shift;
	@{$self->{section_blocks}}
}

sub normalize {
	# useful after deleting items
	my $self = shift;
	my @lines = map { $_->data(1) } $self->section_blocks;
	$self->_group_data(@lines);
}

sub add_item {
	# for use by external users (not this class):
	# add a section if there is none
	my $self = shift;
	my $line = shift;
	if ($self->section_blocks) {
		die "cannot use add_item if there is data"
	}
	my $bd = BlockData->new(0);
	$bd->add($line);
	$self->{section_blocks} = [ $bd ];
}

sub parse_line {
	# Return true if parsing should continue, false
	# otherwise. Aborts on error.
	my $self = shift;
	my $line = shift;
	chomp $line;
	if ($self->in_section) {
		if ($line =~ /^(\s+)(\S+)$/) {
			$self->indent($1);
			my $cur_section_line = $2;
			push @{$self->{tmp_ungrouped_section_lines}},
				$cur_section_line;
			return 1;
		}
		elsif ($line =~ /^\s*$/) {
			# ignore blank lines
			return 1;
		}
		# end of "section"
		elsif ($line =~ /^#/ or $line =~ /^\s+:/) {
			$self->line_after($line);
			$self->_group_data(@{$self->{tmp_ungrouped_section_lines}});
			undef $self->{tmp_ungrouped_section_lines};
			return 0;
		}
		# malformed line
		else {
			say "Section $section is not ended correctly.";
			say "Current line: $line.";
			main::abort();
		}
	}
	else {
		if ($line =~ /^\Q$section\E(\s*)/) {
			say "*   in section $line ($file)";
			say "    warning, trailing whitespace after section name" if ($1);
			$self->line_before($line);
			$self->in_section(1);
		}
		return 1;
	}
}

sub _group_data {
	my $self = shift;
	my @lines = @_;

	# separate by commas (a, b, c d => a , b , c d)
	my @data = ();
	for my $line (@lines) {
		if ($line =~ /,$/) {
			push @data, { line => substr $line, 0, -1 };
			push @data, { sep => 1 }
		}
		else {
			push @data, { line => $line }
		}
	}

	# group by separators (a , b , c d => a | b | c d)
	my @data_grouped = ();
	my @g = ();
	for my $data (@data) {
		if (exists $data->{sep}) {
			push @data_grouped, [ @g ];
			@g = ();
		}
		else {
			push @g, $data->{line}
		}
	}
	push @data_grouped, [ @g ] if @g;

	# group adjacent sections with one item into user friendly "blocks"
	# (a | b | c d => a b | c d)
	# we need to record if it's a "squashed" section to display it correctly
	# later ((squashed=1) a b | (squashed=0) c d)
	my @data_blocks = ();
	for my $grouped (@data_grouped) {
		if (not @data_blocks or @$grouped > 1) {
			# push into new
			my $bd = BlockData->new(@$grouped == 1 ? 1 : 0);
			for (@$grouped) {
				$bd->add($_)
			}
			push @data_blocks, $bd;
		}
		else {
			my $bd;
			my $prev_was_squashed = $data_blocks[-1]->is_squashed;
			if ($prev_was_squashed) {
				# reuse
				$bd = $data_blocks[-1];
			}
			else {
				# create new
				$bd = BlockData->new(1);
				push @data_blocks, $bd;
			}
			$bd->add($grouped->[0])
		}
	}
	$self->{section_blocks} = \@data_blocks;
}
