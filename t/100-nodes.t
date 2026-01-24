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

subtest recognise_nodes => sub {
    use StateTable::Tiny;

    my $stt = StateTable::Tiny->new();

    $stt->add('START', 0, 'START');
    is_deeply [$stt->nodes], ['START'], 'START node added';

    $stt->add('START', 1, 'N1');
    is_deeply [$stt->nodes], ['START'], 'add condition for START->N2';

    $stt->add('N1', 0, 'N10');
    is_deeply [$stt->nodes], [qw/N1 START/], 'node N1 added';

    $stt->add('N10', 1, 'START');
    is_deeply [$stt->nodes], [qw/N1 N10 START/], 'node N10 added';
};

done_testing;
