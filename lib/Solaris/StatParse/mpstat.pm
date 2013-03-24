use strict;
use warnings;

package Solaris::StatParse::mpstat;

use Moose;
use IO::File;

has 'file'       => ( is => 'rw',
                      isa => 'Str', );
has 'date_regex' => ( is => 'ro',
                      isa => 'RegexpRef',
                      default =>
                        sub {
                          qr{^ Mon|Tue|Wed|Thu|Fri|Sat|Sun \s+
                            }x;
                        },
                    );


sub parse_time {
  my $self = shift;

  my $count;
  my $file = $self->file;
  my $fh   = IO::File->new($file, "<") or die "Unable to open $file: $!";
  my $re   = $self->date_regex;

  while (my $line = <$fh>) {
    if ($line =~ m/$re/smx) {
      $count++;
    }
  }
  $fh->close;
  return $count;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
