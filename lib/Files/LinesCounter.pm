package Files::LinesCounter;

use 5.008;
use strict;
use warnings FATAL => 'all';

use JSON;

use Files::Directory;
use Files::Ignore;

sub new {
    my ($class, $args) = @_;

    my $main_path = $args->{main_path};
    my $main_name = $args->{main_name};

    # Initialize the main Repo directory
    my $dir = Files::Directory->new({
        full_path => $main_path,
        path      => $main_name,
        name      => $main_name,
    });

    # Search for all files in that directory
    $dir->search_contents();

    # Initialize ignore file
    my $ignore = Files::Ignore->new();
    $ignore->read_config();

    use Data::Dumper;

    my $self = {
        main_path   => $main_path,
        main_dir    => $dir,
        output_path => $args->{output_path},
        ignore      => $ignore,
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

    open(my $fh, '>', $output_path) or die "Could not open output file '$output_path': $!";

    # Number of total lines in the main directory
    my $total_lines = $main_dir->get_lines();

    # The outputted json
    my $json = {
        contents    => $main_dir->get_json(),
        total_lines => $total_lines,
    };

    # Output our json with indentations and alphabetical keys order
    print $fh JSON->new->indent->space_after->canonical->encode($json);

    close($fh);
}

1;