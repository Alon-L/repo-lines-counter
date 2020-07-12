package File;

use 5.008;
use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, $args) = @_;

    my $self = {
        path => $args->{path},
        name => $args->{name},
    };

    bless $self, $class;
}

# Print the file name
sub print {
    my ($self) = @_;
    my $name = $self->{name};

    print "$name\n";
}

# Return the total number of lines in the file
sub get_lines {
    my ($self) = @_;
    my $path = $self->{path};

    open(my $fh, '<', $path) or die $!;

    my $lines = 0;
    while (<$fh>) {
        $lines++;
    }

    close($fh);

    return $lines;
}

1;