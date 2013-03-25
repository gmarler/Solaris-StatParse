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
  qr{^ (?:Mon|Tue|Wed|Thu|Fri|Sat|Sun) \s+               # Weekday name
       (?<month_name>Jan|Feb|Mar|Apr|May|Jun|
        Jul|Aug|Sep|Oct|Nov|Dec) \s+                     # Month name
       (?<month_day>\d+) \s+
       (?<hour>\d+):(?<minute>\d+):(?<second>\d+) \s+
       \w+ \s+ (?<year>\d{4})
       \n
     $
    }x;
                        },
                    );

my $date_regexes = {
  # TODO: Use named captures
  # LANG=C
  "C" =>
  qr{^ (?:Mon|Tue|Wed|Thu|Fri|Sat|Sun) \s+               # Weekday name
       (?<month_name>Jan|Feb|Mar|Apr|May|Jun|
        Jul|Aug|Sep|Oct|Nov|Dec) \s+                     # Month name
       (?<month_day>\d+) \s+
       (?<hour>\d+):(?<minute>\d+):(?<second>\d+) \s+
       \w+ \s+ (?<year>\d{4})
       \n
     $
    }x,
  # LANG=en_US.UTF-8
  "en_US.UTF-8" =>
  qr{^ (?:Monday|Tuesday|Wednesday|
          Thursday|Friday|Saturday|Sunday), \s+          # Weekday name
       (?<month_name>January|February|March|April|May|
        June|July|August|September|October|November|
        December) \s+                                    # Month name
       (?<month_day>\d+), \s+
       (?<year>\d{4}) \s+
       (?<hour>\d+):(?<minute>\d+):(?<second>\d+) \s+
       (?<am_pm>\w+) \s+ \w+
       \n
     $
    }x,
};

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

      my $dt = DateTime->new( month => $months{$+{month_name}},
                              day => $+{month_day},
                              year => $+{year},
                              hour => $+{hour}, minute => $+{minute},
                              second => $+{second});
      print DateTime::Format::HTTP->format_datetime($dt) . "\n";
    }
  }
  $fh->close;
  return $count;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
