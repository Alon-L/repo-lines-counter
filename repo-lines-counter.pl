#!/usr/bin/perl
use 5.008;
use strict;
use warnings FATAL => 'all';

use File::Basename;

use Files::LinesCounter;
use Git::Manager;

use constant FILE_PATH => dirname(__FILE__);
use constant TEMP_DIR_PATH => FILE_PATH . "/temp";

# Create the 'temp' directory in case it does not exist
mkdir TEMP_DIR_PATH;

my $manager = Git::Manager->new({
    url           => 'https://github.com/Alon-L/repo-lines-counter',
    temp_dir_path => TEMP_DIR_PATH,
});

$manager->clone();
my ($main_path, $main_name) = $manager->get_cloned_dir();

my $counter = Files::LinesCounter->new({
    main_path   => $main_path,
    main_name   => $main_name,
    output_path => FILE_PATH . "/output.json",
});

$counter->out();
