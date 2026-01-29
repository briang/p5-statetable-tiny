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

$stt->add($stt->START, 0, 'S0');
$stt->add('S0', 0, $stt->START);

is $stt->state, $stt->START, 'starts at START';
is $stt->step(0), 'S0', 'advances to S0';

$stt->reset;
is $stt->state, $stt->START, 'resets back to START';

done_testing;
