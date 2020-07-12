#!/usr/bin/perl
use 5.008;
use strict;
use warnings FATAL => 'all';

use Data::Dumper;

use LinesCounter;

my $counter = LinesCounter->new({
    main_path   => 'temp/test-repo',
    main_name   => 'test-repo',
    output_path => 'output.txt',
});

$counter->out();
