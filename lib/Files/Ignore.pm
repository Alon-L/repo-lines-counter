package Files::Ignore;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Cwd qw(abs_path);

use constant IGNORE_CONFIG_PATH => abs_path . '/ignore.json';

use JSON;

my $config_json;

# Returns whether or not a given file is ignored
sub is_file_ignored {
    my ($file_name) = @_;

    return grep { $_ eq $file_name} @{get_ignored_files()};
}

# Returns whether or not a given directory is ignored
sub is_directory_ignored {
    my ($dir_name) = @_;

    return grep { $_ eq $dir_name} @{get_ignored_directories()};
}

# Returns an array of the ignored directory names
sub get_ignored_directories {
    my $config = read_config();

    return $config->{directories};
}

# Returns an array of the ignored file names
sub get_ignored_files {
    my $config = read_config();

    return $config->{files};
}

# Parses the JSON content inside the 'ignore.json' config file and loads them into the 'config' attribute
sub read_config {
    return $config_json if (defined $config_json);

    open my $fh, '<', IGNORE_CONFIG_PATH or die "Could not open ". IGNORE_CONFIG_PATH . " $!";
    my $config_content = do { local $/; <$fh> };
    $config_json = JSON->new->decode($config_content);

    return $config_json;
}

1;