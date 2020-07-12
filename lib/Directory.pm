package Directory;

use 5.008;
use strict;
use warnings FATAL => 'all';

use File;
our @ISA = qw(File);

sub new {
    my ($class, $args) = @_;

    my $self = $class->SUPER::new($args);

    $self->{depth} = $args->{depth} || 0;
    $self->{contents} = [];

    bless $self, $class;
}

sub print {
    my ($self) = @_;
    my $name = $self->{name};
    my $depth = $self->{depth};
    my $contents = $self->{contents};

    print "$name\n";
    foreach my $content (@$contents) {
        print "-" x (($depth + 1) * 12);
        $content->print();
    }
}

sub search_files {
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

            $dir->search_files();

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

sub add_content {
    my ($self, $content) = @_;
    my $contents = $self->{contents};

    push(@$contents, $content);
}

sub get_content_path {
    my ($self, $content_name) = @_;
    my $path = $self->{path};

    return "$path/$content_name";
}

1;