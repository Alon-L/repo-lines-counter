package LinesCounter;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Directory;

sub new {
    my ($class, $args) = @_;

    my $main_path = $args->{main_path};
    my $main_name = $args->{main_name};

    my $dir = Directory->new({
        path => $main_path,
        name => $main_name,
    });

    $dir->search_files();

    my $self = {
        main_path => $main_path,
        main_dir => $dir,
    };

    bless $self, $class;
}

sub get_lines {
    my ($self) = @_;
    my $main_dir = $self->{main_dir};

    return $main_dir->get_lines();
}

1;