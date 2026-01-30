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

use StateTable::Tiny;

subtest basic => sub {
    my $stt = StateTable::Tiny->new();
    ok     $stt, 'new returned something';
    ok ref $stt, 'new returned a reference';
    is ref $stt, 'StateTable::Tiny', 'new returned an STT object';

    my %fields = %StateTable::Tiny::FIELDS;
    for my $method (sort keys %fields) { # keys returns random order
        my $type = $fields{$method};

        is ref $stt->can($method), 'CODE', qq[STT has a "$method" method];

        if ($type eq 'SCALAR') {
            if ($method eq 'state') {
                is $stt->$method, $stt->START, 'state is START at creation';
            } else {
                ok ! defined $stt->$method, qq[$method() returns undef];
            }
        } else {
            is ref $stt->$method, $type, qq[$method() returns a $type];
        }
    }

};

subtest recognise_states => sub {
    my $stt = StateTable::Tiny->new();

    $stt->add($stt->START, 0, $stt->START);
    is_deeply [$stt->states], [$stt->START], 'START state added';
    ok $stt->is_valid(), "START is properly defined and referenced";

    $stt->add($stt->START, 1, 'N1');
    is_deeply [$stt->states], [$stt->START], 'add condition for START->N2';
    ok ! $stt->is_valid(), "N1 state is not defined";

    $stt->add('N1', 0, 'N10');
    is_deeply [$stt->states], ['N1', $stt->START], 'state N1 added';
    ok ! $stt->is_valid(), 'N10 state is not defined';

    $stt->add('N10', 1, $stt->START);
    is_deeply [$stt->states], [qw/N1 N10/, $stt->START], 'state N10 added';
    ok $stt->is_valid(), 'network is properly defined & referenced';
};

subtest simple_machine => sub {
    my $stt = StateTable::Tiny->new();

    # Defaults: Starts at START and ends at ACCEPT or REJECT

    # Accept a string containing "01"
    $stt->add($stt->START, 0, 'S0');
    $stt->add($stt->START, 1, $stt->START);

    $stt->add('S0', 0, 'S0');
    $stt->add('S0', 1, $stt->ACCEPT);

    # inputs are 1,1,0,0,1
    is $stt->step(1), $stt->START, '1: START (1st)';
    is $stt->step(1), $stt->START, '1: START (2nd)';
    is $stt->step(0), 'S0',    '0: S0 (1st)';
    is $stt->step(0), 'S0',    '0: S0 (2nd)';
    is $stt->step(1), $stt->ACCEPT, '1: ACCEPT';
    is $stt->step(1), undef, 'error, already finished';
};

subtest invalid_input => sub {
    my $stt = StateTable::Tiny->new();

    $stt->add($stt->START, 0, 'S0');
    $stt->add($stt->START, 1, $stt->START);

    is $stt->step(999), undef, 'current state has no rule for input';
};

subtest topic_variable => sub {
    my $stt = StateTable::Tiny->new();

    $stt->add($stt->START, 0, 'S0');
    $stt->add('S0', 0, $stt->START);

    $_ = 'hi';
    my $state = $stt->step(0);
    is $state, 'S0', 'transition to S0';
    is $_, 'hi', 'topic variable is unchanged';
};

subtest reset => sub {
    my $stt = StateTable::Tiny->new();

    $stt->add($stt->START, 0, 'S0');
    $stt->add('S0', 0, $stt->START);

    is $stt->state, $stt->START, 'starts at START';
    is $stt->step(0), 'S0', 'advances to S0';

    $stt->reset;
    is $stt->state, $stt->START, 'resets back to START';
};

subtest conditions => sub {
    my $stt = StateTable::Tiny->new();

    $stt->add($stt->START, 'string',               'STRING');
    $stt->add($stt->START, qr/regex/,              'REGEX');
    $stt->add($stt->START, sub { $_ eq 'sub' },    'CODE');
    $stt->add($stt->START, sub { $_[0] eq 'sub' }, 'CODE');

    my $state;

    $stt->reset;
    $state = $stt->step('string');
    is $state, 'STRING', 'string match working';

    $stt->reset;
    $state = $stt->step('la la la regex la la');
    is $state, 'REGEX', 'regex match working';

    $stt->reset;
    $state = $stt->step('sub');
    is $state, 'CODE', 'subref match working (using $_)';

    $stt->reset;
    $state = $stt->step('sub');
    is $state, 'CODE', 'subref match working (using @_)';
};

done_testing;
