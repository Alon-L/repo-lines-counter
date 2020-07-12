#!/usr/bin/perl
use 5.008;
use strict;
use warnings FATAL => 'all';

use Data::Dumper;

use LinesCounter;

my $counter = LinesCounter->new({
    dir_path => './temp/test-repo',
});

my $files = $counter->search_dir();
$counter->print_dir($files);