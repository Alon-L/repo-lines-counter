#!/usr/bin/env perl

use 5.008;
use strict;
use warnings FATAL => 'all';

use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(abs_path($0)) . '/lib';

use Files::LinesCounter;
use Git::Manager;

use constant TEMP_DIR_PATH => abs_path . "/temp";
use constant OUTPUT_FILE_PATH => abs_path . "/output.json";

# Create the 'temp' directory in case it does not exist
mkdir TEMP_DIR_PATH;

# Reads the repository URL from the given arguments
my ($repo) = @ARGV;
die "Repository not provided" unless (defined $repo);

my $manager = Git::Manager->new({
    url           => $repo,
    temp_dir_path => TEMP_DIR_PATH,
});

$manager->clone();
my ($main_path, $main_name) = $manager->get_cloned_dir();

my $counter = Files::LinesCounter->new({
    main_path   => $main_path,
    main_name   => $main_name,
    output_path => OUTPUT_FILE_PATH,
});

$counter->out();
