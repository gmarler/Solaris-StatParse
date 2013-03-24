use strict;
use warnings;

use Test::More tests => 5;                      # last test to print
use FindBin;


use_ok("Solaris::StatParse::mpstat");

my $mpstat = Solaris::StatParse::mpstat->new();
isa_ok( $mpstat, "Solaris::StatParse::mpstat");

my $file1 = "$FindBin::Bin/data/mpstat.1";

$mpstat = Solaris::StatParse::mpstat->new( file => $file1 );
isa_ok( $mpstat, "Solaris::StatParse::mpstat");
ok( $mpstat->file() eq $file1, "Stored file is $file1" );

#warn $mpstat->dump;

# TODO: Take above and put into a test for the file attribute
#
ok( $mpstat->parse_time() == 10, "Found 10 times" );
