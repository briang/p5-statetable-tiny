#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;

# use Data::Dump; # XXX

BEGIN {
    if ($ENV{INSIDE_EMACS}) {
        eval q(use FindBin '$Bin'; use lib "$Bin/../lib"; 1) or die 'I died';
    }
}

use Test::More;

subtest recognise_a_node => sub {
    use StateTable::Tiny;

    my $stt = StateTable::Tiny->new();

    $stt->add('START', 0, 'START');
    is_deeply [$stt->nodes], ['START'], 'one node added';

    $stt->add('START', 1, 'START');
    is_deeply [$stt->nodes], ['START'], 'no new nodes added';
};

done_testing;
