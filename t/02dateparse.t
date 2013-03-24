use strict;
use warnings;

use Test::More tests => 4;                      # last test to print
use FindBin;


use_ok("Solaris::StatParse::mpstat");

my $mpstat = Solaris::StatParse::mpstat->new();
isa_ok( $mpstat, "Solaris::StatParse::mpstat");

my $file1 = "$FindBin::Bin/data/mpstat.1";

$mpstat = Solaris::StatParse::mpstat->new( file => $file1 );
isa_ok( $mpstat, "Solaris::StatParse::mpstat");
ok( $mpstat->file() eq $file1, "Stored file is $file1" );
