#!/usr/bin/env perl

use v5.10;

use strict;
use warnings;

# use Data::Dump; # XXX

BEGIN {
    if ($ENV{INSIDE_EMACS}) {
        eval q(use FindBin '$Bin'; use lib "$Bin/../lib"; 1) or die 'I died';
    }
}

use Test::More;

subtest recognise_states => sub {
    use StateTable::Tiny;

    my $stt = StateTable::Tiny->new();

    $stt->add('START', 0, 'START');
    is_deeply [$stt->states], ['START'], 'START state added';
    ok $stt->is_valid(), "START is properly defined and referenced";

    $stt->add('START', 1, 'N1');
    is_deeply [$stt->states], ['START'], 'add condition for START->N2';
    ok ! $stt->is_valid(), "N1 state is not defined";

    $stt->add('N1', 0, 'N10');
    is_deeply [$stt->states], [qw/N1 START/], 'state N1 added';
    ok ! $stt->is_valid(), 'N10 state is not defined';

    $stt->add('N10', 1, 'START');
    is_deeply [$stt->states], [qw/N1 N10 START/], 'state N10 added';
    ok $stt->is_valid(), 'network is properly defined & referenced';
};

done_testing;
