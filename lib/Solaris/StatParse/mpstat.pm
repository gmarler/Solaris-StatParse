use strict;
use warnings;

package Solaris::StatParse::mpstat;

use Moose;

has 'file'       => ( is => 'rw',
                      isa => 'Str', );
has 'date_regex' => ( is => 'ro',
                      isa => 'RegexRef',
                    );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
