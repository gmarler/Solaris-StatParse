use strict;
use warnings;

package Solaris::StatParse::mpstat;

use Moose;
use IO::File;
use DateTime;
use DateTime::Format::HTTP;

has 'file'       => ( is => 'rw',
                      isa => 'Str', );
has 'date_regex' => ( is => 'ro',
                      isa => 'RegexpRef',
                      default =>
                        sub {
                          qr{^ (?:Mon|Tue|Wed|Thu|Fri|Sat|Sun) \s+
                               (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)
                               \s+ (\d+) \s+ (\d+):(\d+):(\d+) \s+
                               \w+ \s+ (\d{4})
                               \n
                             $
                            }x;
                        },
                    );

my %months = ( 'Jan'       => 1, 'January'   => 1,
               'Feb'       => 2, 'February'  => 2,
               'Mar'       => 3, 'March'     => 3,
               'Apr'       => 4, 'April'     => 4,
               'May'       => 5,
               'Jun'       => 6, 'June'      => 6,
               'Jul'       => 7, 'July'      => 7,
               'Aug'       => 8, 'August'    => 8,
               'Sep'       => 9, 'September' => 9,
               'Oct'       => 10, 'October'   => 10,
               'Nov'       => 11, 'November'  => 11,
               'Dec'       => 12, 'December'  => 12,
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
      my ($month,$day,$hour,$minute,$second,$year) =
        ($months{$1},$2,$3,$4,$5,$6);

      my $dt = DateTime->new( month => $month, day => $day, year => $year,
                              hour => $hour, minute => $minute,
                              second => $second);
      print DateTime::Format::HTTP->format_datetime($dt) . "\n";
    }
  }
  $fh->close;
  return $count;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
