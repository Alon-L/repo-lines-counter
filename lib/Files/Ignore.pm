package Files::Ignore;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Cwd qw(abs_path);
use constant IGNORE_CONFIG_PATH => abs_path . '/ignore.json';

use JSON;

sub new {
    my ($class, $args) = @_;

    my $self = {
        config => undef,
    };

    bless $self, $class;
}

sub read_config {
    my ($self) = @_;
    my $config = $self->{config};

    return $config if (defined $config);

    open my $fh, '<', IGNORE_CONFIG_PATH or die "Could not open ". IGNORE_CONFIG_PATH . " $!";
    my $config_content = do { local $/; <$fh> };
    my $config_json = JSON->new->decode($config_content);

    return $self->{config} = $config_json;
}

1;