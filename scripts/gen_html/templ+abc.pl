#!/usr/bin/env perl

# Copyright (C) 2012, Enlik

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use warnings;
use strict;
use Getopt::Long;
use HTML::Template;
use 5.010;

# This makes accessing edition's data more clear.
# Class EditionItem stores URL, size and date for an edition for one
# architecture, for one file type (which means that one EditionType
# is needed for an .iso, another one for a .md5sum file and so on).
# We don't use, for example, size for .md5 files, but just in case it changes...
{
	package EditionItem;
	my ($href, $size, $date);
	sub new {
		my $class = shift;
		my %self = @_;
		for my $item (qw(url size date)) {
			die "EditionItem::new(): $item not defined"
				unless defined $self{$item}
		}
		bless \%self, $class;
	}
	sub url  { $_[0]->{url}  }
	sub size { $_[0]->{size} }
	sub date { $_[0]->{date} }
	sub toString {
		my $self = shift;
		my ($url, $size, $date) = ($self->{url}, $self->{size}, $self->{date});
		return "$url (size = $size, date = $date)";
	}
}

# $sab{edition}->{arch}->{type} = EditionItem
# type is one of: ".md5", ".pkglist", ".torrent", ""

my %sab;
my @oth;
my $tmpl;

sub print_other {
	return unless @oth;
	my @others_loop_data;
	for my $item (@oth) {
		push @others_loop_data, { url => $item->[0], name => $item->[1] }
	}
	$tmpl->param(others_loop => \@others_loop_data);
}

# Adds elements to template which will be printed.
# $regex is a regular expression to specify which arches to select;
# $negate - if true, $regex will be negated;
# $editions_loop_arch - name of the loop in template to use;
# $extra_fields - what to pass to template besides for "" and ".md5",
#   for example ".pkglist" to pass .pkglist for arches/editions which have
#   such files; supported types: ".pkglist" and ".torrent"
sub print_items {
	my ($regex, $negate, $editions_loop_arch, $extra_fields) = @_;
	my $match;
	my %extra_fields = map { $_ => 1 } @{ $extra_fields };
	my @editions_loop_data = ();

	for my $edition (sort keys %sab) {
		my $displayed_edition = 0;
		my @arches_loop_data = ();

		for my $arch (sort keys %{ $sab{$edition} }) {
			$match = $arch =~ $regex;
			$match = !$match if $negate;
			next unless $match;
			# these are EditionItem objects
			my $ISO     = $sab{$edition}->{$arch}->{""};
			my $md5     = $sab{$edition}->{$arch}->{".md5"};
			my $pkglist = $sab{$edition}->{$arch}->{".pkglist"}
				if $extra_fields{".pkglist"};
			my $torrent = $sab{$edition}->{$arch}->{".torrent"}
				if $extra_fields{".torrent"};

			for my $item (qw(.torrent .pkglist)) {
				if (defined $sab{$edition}->{$arch}->{$item}
					and not $extra_fields{$item}) {
					warn "Warning: file type $item not specified to print, ",
						"but it is available for $edition -> $arch: ",
						$sab{$edition}->{$arch}->{$item}->url
				}
			}

			my %arches_loop_row; # fresh hash for new arch

			$arches_loop_row{name} = $edition;
			$arches_loop_row{arch} = $arch;

			# any item is counted, even if there's no ISO but only md5sum
			# not too pretty, but fast enough
			$arches_loop_row{arches_per_edition} = 0;
			for my $arch (keys %{ $sab{$edition} }) {
				my $match = $arch =~ $regex;
				$match = !$match if $negate;
				$arches_loop_row{arches_per_edition}++ if $match;
			}

			# Some of them (ISO, md5, pkglist) may be not defined,
			# depending on available file types.
			# If x is defined, then x->url, x->size and x->time are defined.
			# Note: size and date for non-ISO-like files are discarded here.
			if (defined $ISO) {
				$arches_loop_row{mainfile_url}  = $ISO->url;
				$arches_loop_row{mainfile_size} = $ISO->size;
				$arches_loop_row{mainfile_date} = $ISO->date;
			}
			if (defined $md5) {
				$arches_loop_row{md5_url}  = $md5->url;
				#$arches_loop_row{md5_size} = $md5->size;
				#$arches_loop_row{md5_date} = $md5->date;
			}
			if (defined $pkglist) {
				$arches_loop_row{pkglist_url}  = $pkglist->url;
				#$arches_loop_row{pkglist_size} = $pkglist->size;
				#$arches_loop_row{pkglist_date} = $pkglist->date;
			}
			if (defined $torrent) {
				$arches_loop_row{torrent_url}  = $torrent->url;
			}

			# push data (name, download links, ...) for an architecture
			push @arches_loop_data, \%arches_loop_row;
		}
		# say "</p>" if $displayed_edition;
		# with nested loops this template thingy goes a little obscure...
		push @editions_loop_data, { arches_loop => \@arches_loop_data }
			if (@arches_loop_data);
	}
	$tmpl->param($editions_loop_arch => \@editions_loop_data);
}

sub add_item {
	my ($edition, $arch, $type, $href, $size, $mdate) = @_;
	die "add_item: args!\n" unless @_ == 6;

	if (defined $sab{$edition}->{$arch}->{$type}) {
		my $ei = $sab{$edition}->{$arch}->{$type};
		warn "Warning: already defined! ($edition, $arch, $type), item = ",
			$ei->toString, "\n";
	}

	$sab{$edition}->{$arch}->{$type} =
		EditionItem->new (url => $href, size => $size, date => $mdate);
}

# Parse file name and add using add_item. First argument is file name; second
# argument is prefix (see help for --prefix).
# The rest will be passed to add_item (it's used to pass additional attributes
# gathered by caller).
sub parse_entry {
	my $href = shift;
	my $prefix = shift;
	my @extra_args = @_;
	my $href_full = $href;
	my $type_ext = "";

	# find file type
	for my $ext (qw(.md5 .pkglist .torrent)) {
		if ($href =~ /\Q${ext}\E$/) {
			$type_ext = $ext;
			$href =~ s/\Q${ext}\E$//; # part without "well known extension"
			last;
		}
	}

	my $href_link = $prefix . $href_full;

	my $re_pref = "Sabayon_Linux";
	my $re_arch = "(?<arch>[^_]+)";
	# If numeration schema changes, look at $re_ver. :)
	# $re_ver part can't be too loose because it would match something else
	# than release type...
	my $re_ver  = "(?<ver>DAILY|[0-9]+)";

	my $fmt = sub {
		my ($ver, $ed) = @_;
		$ver eq "DAILY" ? $ed : qq{Sabayon $ver "$ed"};
	};

	# Sabayon_Linux_DAILY_amd64_E17.iso
	if ($href =~ /^${re_pref}_${re_ver}_${re_arch}_(?<ed>[^_]+)\.iso$/) {
		my $ed = $fmt->($+{ver}, $+{ed});
		add_item ($ed, $+{arch}, $type_ext, $href_link, @extra_args);
	}

	# Sabayon_Linux_CoreCDX_DAILY_amd64.iso
	elsif ($href =~ /^${re_pref}_(?<ed>[^_]+)_${re_ver}_${re_arch}\.iso$/) {
		my $ed = $fmt->($+{ver}, $+{ed});
		add_item ($ed, $+{arch}, $type_ext, $href_link, @extra_args);
	}

	# Sabayon_Linux_SpinBase_DAILY_x86_openvz.tar.gz
	elsif ($href =~ /^${re_pref}_(?<ed>[^_]+)_${re_ver}_${re_arch}_(?<ed_misc>.+)\.tar\.gz$/) {
		# there's no such non-daily rel., but just in case; same for a few others
		my $ed = $fmt->($+{ver}, $+{ed});
		add_item ("$ed ($+{ed_misc}; .tar.gz)", $+{arch},
			$type_ext, $href_link, @extra_args);
	}

	# Sabayon_Linux_DAILY_armv7a_(misc).img.xz
	elsif ($href =~ /^${re_pref}_${re_ver}_${re_arch}_(?<ed>.+)\.img\.xz$/) {
		my $ed = $fmt->($+{ver}, $+{ed});
		add_item ("$ed (.img.xz)", $+{arch},
			$type_ext, $href_link, @extra_args);
	}

	# Sabayon_Linux_DAILY_armv7a_BeagleBone_Base_4GB.img.rootfs.tar.xz
	elsif ($href =~ /^${re_pref}_${re_ver}_${re_arch}_(?<ed>.+)(?<ext>\.img\.[^.]+\.tar\.xz)$/) {
		my $ed = $fmt->($+{ver}, $+{ed});
		add_item ("$ed ($+{ext})", $+{arch},
			$type_ext, $href_link, @extra_args);
	}

	# Sabayon_Linux_DAILY_armv7a_BeagleBone_Base_16GB.img
	elsif ($href =~ /^${re_pref}_${re_ver}_${re_arch}_(?<ed>.+)\.img$/) {
		my $ed = $fmt->($+{ver}, $+{ed});
		add_item ("$ed (.img)", $+{arch},
			$type_ext, $href_link, @extra_args);
	}

	else {
		push @oth, [ $href_link, $href_full ]
	}
}

# Read directory and call subroutines to build data structures.
sub generate {
	if (1) {
		my ($dir_to_open, $prefix, $opt_skip) = @_;
		if (not defined $dir_to_open or not defined $prefix) {
			die "generate: need 2 arguments!";
		}

		opendir (my $dh, $dir_to_open)
			or die "Cannot open directory $dir_to_open: $!\n";
		my %opt_skip = map { $_ => 1 } @{ $opt_skip };

		while (my $item = readdir ($dh)) {
			# next if $item eq ".."; # we want "." I think
			next if $opt_skip{$item};

			my $item_path = $dir_to_open . "/" . $item;
			my ($size, $mdate);
			my @st = stat($item_path);
			if (@st) {
				($size, $mdate) = @st[7,9];
				$size = "<dir>" if (-d _);
			}
			else {
				say STDERR "Cannot stat $item_path: $!";
				$mdate = $size = "???";
			}
	
			# make pretty $size if it's a number
			if ($size =~ /^[0-9]/) {
				my @units = qw(B KiB MiB);
				my $level = 0;
				while ($size >= 2000) {
					last if $level == $#units;
					$size /= 1024;
					$level++;
				}
				if ($level > 0 and $size != int($size)) {
					$size = int (100*$size + 0.5) / 100;
					$size = sprintf ("%.2f", $size);
				}
				$size .= " " . $units[$level];
			}
	
			# make pretty $mdate if it's not unknown
			if ($mdate =~ /^[0-9]/) {
				my ($day, $mth, $year) = (localtime($mdate)) [3,4,5];
				$mth++;
				$year += 1900;
				$mth = "0" . $mth if $mth < 10;
				$mdate = "$day.$mth.$year";
			}
	
			parse_entry ($item, $prefix, $size, $mdate);
		}
		closedir ($dh);
	}
	# read from downloaded listing (wget .../iso), good for testing purposes
	# ignores any argument
	else {
		my $filename = "daily.html";
		open my $fh, "<", $filename or die "Cannot open file $filename! $!\n";
		
		while (my $line = <$fh>) {
			if ($line =~ /\<a href="([^ "]+)"\>/) {
				parse_entry ($1, "", "(size)", "(date)");
			}
		}
		close $fh;
	}
}

my ($arg_type, $opt_help, $opt_template, $opt_dir, $opt_prefix) = ("") x 5;
my @opt_skip;
my $opts = GetOptions(
	"template=s"  => \$opt_template,
	"help"        => \$opt_help,
	"dir=s"       => \$opt_dir,
	"prefix=s"    => \$opt_prefix,
	"skip=s"      => \@opt_skip,
);

if ($opt_help) {
	print <<END;
Usage: templ+abc.pl [OPTION]... TYPE
Writes a HTML document to standard output as a result of processing a directory
(current directory by default) for release type TYPE.
TYPE means release type; valid values: "main" or "daily".
It is used to create a friendly document with listing of Sabayon releases
with download links.

Options:
--template - template to use; defaults to <type>.tmpl
--dir - directory with file entries to process (.ISO files and so on;
  defaults to current directory)
--prefix - prefix appended to each link; for example if you want to place
  resulting HTML document under /var/www and you use --dir /var/www/s/iso,
  you may need to specify --prefix s/iso/ so download links point to the
  proper location (note the trailing slash)
--skip - file name to skip (especially useful to skip unwanted files listed
  under "Others" section); this option can be specified multiple times
--help - shows this help
END
	exit 0;
}

if (@ARGV != 1) {
	die "You must provide one argument TYPE. See --help.\n"
}
$arg_type = shift;

unless ($arg_type ~~ [ qw(main daily) ]) {
	die "Invalid argument TYPE. See --help.\n"
}

my $template_name;
if ($opt_template ne "") {
	$template_name = $opt_template;
}
else {
	$template_name = $arg_type . ".tmpl";
}

# Open template itself to avoid 2-argument open() idiocy.
open my $tmpl_fh, "<", $template_name
	or die "Cannot open file $template_name: $!\n";
$tmpl = HTML::Template->new(filehandle => $tmpl_fh,
	loop_context_vars => 1);
close $tmpl_fh;

generate($opt_dir || ".", $opt_prefix, \@opt_skip);

if ($arg_type eq "daily") {
	# x86 & amd86 first
	print_items ( qr/amd64|x86/, 0, "intel_editions_loop", [ qw(.pkglist) ] );
	print_items ( qr/amd64|x86/, 1, "nonintel_editions_loop", [] );
}
else {
	print_items ( qr/.*/, 0, "intel_editions_loop", [ qw(.pkglist .torrent) ] );
}
print_other ();

# get rid of those stupid blank lines (leaving /^$/ ones which may be used
# to prettify output) for some small penalty cost
for my $line (split /\n/,$tmpl->output) {
	say "$line" unless $line =~ /^\s+$/;
}
