package Files::Directory;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Files::File;
our @ISA = qw(Files::File);

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

# Returns the JSON data for this directory
sub get_json {
    my ($self) = @_;
    my $name = $self->{name};
    my $path = $self->{path};
    my $contents = $self->{contents};

    my %contents_json = map {%{$_->get_json()}} @$contents;

    my $total_lines = $self->get_lines();

    return {
        $name => {
            path        => $path,
            contents    => \%contents_json,
            total_lines => $total_lines,
        }
    }
}

# Returns the total number of lines of all the content this directory includes
sub get_lines {
    my ($self) = @_;
    my $contents = $self->{contents};
    my $total_lines = $self->{total_lines};

    return $total_lines if (defined $total_lines);

    my $lines = 0;

    foreach my $content (@$contents) {
        $lines += $content->get_lines();
    }

    return $total_lines = $lines;
}

# Prints the indentation for this directory
sub print_indent {
    my ($self) = @_;
    my $depth = $self->{depth};

    print "└", "─" x (($depth + 1) * INDENT), " ";
}

# Prints this directory and all of its content
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
    my $full_path = $self->{full_path};
    my $depth = $self->{depth};

    opendir(my $dh, $full_path) or die "Cannot open directory '$full_path': $!";

    while (my $content_name = readdir($dh)) {
        # Ignore "." and ".." on Unix based systems
        next if ($content_name =~ m/^\.\.?$/);

        # The content path relative to the root directory
        my $content_path = $self->get_content_path($content_name);

        # The full content path
        my $content_full_path = $self->get_content_full_path($content_name);

        if (-d $content_full_path) {
            # This is a sub-directory
            my $dir = Files::Directory->new({
                full_path => $content_full_path,
                path      => $content_path,
                name      => $content_name,
                depth     => $depth + 1,
            });

            $dir->search_contents();

            $self->add_content($dir);
        }
        else {
            # This is a normal file
            my $file = Files::File->new({
                full_path => $content_full_path,
                path      => $content_path,
                name      => $content_name,
            });

            $self->add_content($file);
        }
    }

    closedir($dh);
}

# Adds content to the contents array
sub add_content {
    my ($self, $content) = @_;
    my $contents = $self->{contents};

    push(@$contents, $content);
}

# Returns the relative path of a content
sub get_content_path {
    my ($self, $content_name) = @_;
    my $path = $self->{path};

    return "$path/$content_name";
}

# Returns the full path of a content
sub get_content_full_path {
    my ($self, $content_name) = @_;
    my $full_path = $self->{full_path};

    return "$full_path/$content_name";
}

1;