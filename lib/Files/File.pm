package Files::File;

use 5.008;
use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, $args) = @_;

    my $self = {
        full_path => $args->{full_path},
        path      => $args->{path},
        name      => $args->{name},
    };

    bless $self, $class;
}

# Returns the JSON data for this file
sub get_json {
    my ($self) = @_;
    my $path = $self->{path};
    my $name = $self->{name};
    my $total_lines = $self->get_lines();

    return {
        $name => {
            path        => $path,
            total_lines => $total_lines,
        },
    }
}

# Prints the file name
sub print {
    my ($self) = @_;
    my $name = $self->{name};
    my $lines = $self->get_lines();

    print "$name ($lines lines)\n";
}

# Returns the total number of lines in the file
sub get_lines {
    my ($self) = @_;
    my $full_path = $self->{full_path};

    open(my $fh, '<', $full_path) or die "Could not open file '$full_path' $!";

    my $lines = 0;
    while (<$fh>) {
        $lines++;
    }

    close($fh);

    return $lines;
}

1;