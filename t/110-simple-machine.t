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

my $stt = StateTable::Tiny->new();

# Defaults: Starts at START and ends at ACCEPT or REJECT

# Accept a string containing "01"
$stt->add($stt->START, 0, 'S0');
$stt->add($stt->START, 1, $stt->START);

$stt->add('S0', 0, 'S0');
$stt->add('S0', 1, $stt->ACCEPT);

# inputs are 1,1,0,0,1
is $stt->step(1), $stt->START, '1: START';
is $stt->step(1), $stt->START, '1: START';
is $stt->step(0), 'S0',    '0: S0';
is $stt->step(0), 'S0',    '0: S0';
is $stt->step(1), $stt->ACCEPT, '1: ACCEPT';
is $stt->step(1), undef, 'error, already finished';

done_testing;
