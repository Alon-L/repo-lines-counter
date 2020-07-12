package LinesCounter;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Directory;

sub new {
    my ($class, $args) = @_;

    my $main_path = $args->{main_path};
    my $main_name = $args->{main_name};

    # Initialize the main Repo directory
    my $dir = Directory->new({
        path => $main_path,
        name => $main_name,
    });

    # Search for all files in that directory
    $dir->search_contents();

    my $self = {
        main_path   => $main_path,
        main_dir    => $dir,
        output_path => $args->{output_path},
    };

    bless $self, $class;
}

# Return the total number of lines in the main directory
sub get_lines {
    my ($self) = @_;
    my $main_dir = $self->{main_dir};

    return $main_dir->get_lines();
}

# Prints the main directory's information to the output file
sub out {
    my ($self) = @_;
    my $main_dir = $self->{main_dir};
    my $output_path = $self->{output_path};

    open(my $fh, '>', $output_path) or die "Could not open output file '$output_path' $!";

    $main_dir->print($fh);

    my $total_lines = $main_dir->get_lines();
    print $fh "\nTotal: $total_lines lines";

    close($fh);
}

1;