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

sub print {
    my ($self) = @_;
    my $name = $self->{name};

    print "$name\n";
}

sub get_lines {
    my ($self) = @_;
    my $path = $self->{path};

    open(my $fh, '<', $path) or die $!;

    my $lines = 0;
    while (<$fh>) {
        $lines++;
    }

    return $lines;
}

1;