package Git::Manager;

use 5.008;
use strict;
use warnings FATAL => 'all';

use File::Path 'rmtree';
use File::Find;

sub new {
    my ($class, $args) = @_;

    my $self = {
        url           => $args->{url},
        temp_dir_path => $args->{temp_dir_path},
    };

    bless $self, $class;
}

# Destructure for the Manager class
sub DESTROY {
    my ($self) = @_;
    my $temp_dir_path = $self->{temp_dir_path};

    # Delete the cloned directory
    rmtree($temp_dir_path, { keep_root => 1 }) or die "Could not remove '$temp_dir_path': $!";
}

# Clone the repository into the 'temp' directory
sub clone {
    my ($self) = @_;
    my $url = $self->{url};
    my $temp_dir_path = $self->{temp_dir_path};

    # Change the working directory into the 'temp' directory
    chdir $temp_dir_path;
    system("git", "clone", $url, "--depth", "1", "--q");
    chdir;
}

# Returns the full path of the cloned directory and its name
sub get_cloned_dir {
    my ($self) = @_;
    my $temp_dir_path = $self->{temp_dir_path};

    opendir(my $dh, $temp_dir_path);

    # Finds the first directory in the 'temp' directory
    my $dir_name = (grep {-d "$temp_dir_path/$_" && ! /^\.{1,2}$/} readdir($dh))[0];

    closedir($dh);

    return ("$temp_dir_path/$dir_name", $dir_name);
}

1;