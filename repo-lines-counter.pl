#!/usr/bin/perl
use 5.008;
use strict;
use warnings FATAL => 'all';

use Data::Dumper;

use Files::LinesCounter;

my $counter = files::LinesCounter->new({
    main_path   => 'temp/test-repo',
    main_name   => 'test-repo',
    output_path => 'output.json',
});

$counter->out();
