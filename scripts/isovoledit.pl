#!/usr/bin/perl
use strict;
use warnings;

die "Use: $0 <iso_file> <new volume id>\n" unless @ARGV == 2;
open my $file, "+<", $ARGV[0] or die "Cannot open: $!";
seek $file, 0x8028,0;
printf $file "%-32.32s", uc($ARGV[1]);
