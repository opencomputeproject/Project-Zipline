#!/usr/bin/perl
# *************************************************************************
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License.
#
# *************************************************************************

require 5.0;

require Exporter;
use strict;
use warnings;
use File::Basename;
use Data::Dumper;

my $testname = "sample";

my $raw_config_file = $testname . ".raw_config";
my $output_file = $testname . ".config";

open(my $raw_fh, "<", $raw_config_file) or die "Can't open database file: $raw_config_file [$!]\n";
open(my $out_fh, ">", $output_file) or die "Can't open database file: $output_file [$!]\n";

my $line_count = 0;
while(my $line = <$raw_fh>) {
    #print $line;
    if($line =~ /\@\@([rw])\@\@(\s0x[0-9a-f]+)(\s0x[0-9a-f]+)/) {
	if( (eval $2) > 0x188 ) {
	    print $out_fh $1,$2,$3,"\n";
	}
    }
#    $line_count+=1;
#    if($line_count >=80 ) {
#	last;
#    }
}

close $raw_fh;
close $out_fh;
