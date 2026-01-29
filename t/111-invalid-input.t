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
$stt->add($stt->START, 1, $stt->START);

is $stt->step(999), undef, 'current state has no rule for input';

done_testing;
