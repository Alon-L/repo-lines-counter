package Directory;

use 5.008;
use strict;
use warnings FATAL => 'all';

use File;
our @ISA = qw(File);

use constant INDENT => 8;

sub new {
    my ($class, $args) = @_;

    my $self = $class->SUPER::new($args);

    # The depth of this directory relatively to the tree structure
    $self->{depth} = $args->{depth} || 0;
    # Array to include all files and sub-directories
    $self->{contents} = [];

    bless $self, $class;
}

# Return the total number of lines of all the content this directory includes
sub get_lines {
    my ($self) = @_;
    my $contents = $self->{contents};

    my $lines = 0;

    foreach my $content (@$contents) {
        $lines += $content->get_lines();
    }

    return $lines;
}

# Print the indentation for this directory
sub print_indent {
    my ($self) = @_;
    my $depth = $self->{depth};

    print "└", "─" x (($depth + 1) * INDENT), " ";
}

# Print this directory and all of its content
sub print {
    my ($self) = @_;
    my $name = $self->{name};
    my $contents = $self->{contents};

    print "$name\n";
    # Print all content
    foreach my $content (@$contents) {
        $self->print_indent();
        $content->print();
    }
}

# Searches for all the contents in this directory, and loads them into the contents array
sub search_contents {
    my ($self) = @_;
    my $path = $self->{path};
    my $depth = $self->{depth};

    opendir(my $dh, $path) or die "Cannot open directory '$path': $!";

    while (my $content_name = readdir($dh)) {
        # Ignore "." and ".." on Unix based systems
        next if ($content_name =~ m/^\.\.?$/);

        my $content_path = $self->get_content_path($content_name);

        if (-d $content_path) {
            # This is a sub-directory
            my $dir = Directory->new({
                path => $content_path,
                name => $content_name,
                depth => $depth + 1,
            });

            $dir->search_contents();

            $self->add_content($dir);
        } else {
            # This is a normal file
            my $file = File->new({
                path => $content_path,
                name => $content_name,
            });

            $self->add_content($file);
        }
    }

    closedir($dh);
}

# Add content to the contents array
sub add_content {
    my ($self, $content) = @_;
    my $contents = $self->{contents};

    push(@$contents, $content);
}

# Return the full path of a content
sub get_content_path {
    my ($self, $content_name) = @_;
    my $path = $self->{path};

    return "$path/$content_name";
}

1;