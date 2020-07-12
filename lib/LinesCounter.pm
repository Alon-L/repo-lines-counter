package LinesCounter;

use 5.008;
use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, $args) = @_;
    my $self = {
        dir_path => $args->{dir_path}
    };
    bless $self, $class;
}

sub print_dir {
    my ($self, $files, $indent) = @_;
    # Default indent should be none
    $indent ||= 0;

    foreach my $dir (keys %$files) {
        # Print the directory name
        print "-" x ($indent * 12), "$dir\n";

        # Print the files and sub-directories
        foreach my $file (values @{%$files{$dir}}) {
            if (ref($file) eq 'HASH') {
                # Print the subdirectory
                $self->print_dir($file, $indent + 1);
            } else {
                # Print the file
                print "-" x (($indent + 1) * 12), "$file\n";
            }
        }
    }
}

# Searches for all files in a directory and its sub-directories
sub search_dir {
    my ($self, $subdir_path) = @_;
    my $dir_path = $subdir_path || $self->{dir_path};

    opendir(my $dh, $dir_path) or die "Cannot open directory '$dir_path': $!";

    my @files;

    while (my $file = readdir($dh)) {
        # Ignore "." and ".." on Unix based systems
        next if ($file =~ m/^\.\.?$/);

        my $path = "$dir_path/$file";

        if (-d $path) {
            # This is a sub-directory - read it
            push(@files, $self->search_dir($path));
        } else {
            push(@files, $path);
        }
    }

    closedir($dh);

    return { $dir_path => \@files };
}

1;