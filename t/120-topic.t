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

$_ = 'hi';
my $state = $stt->step(0);
is $state, 'S0', 'transition to S0';
is $_, 'hi', 'topic variable is unchanged';

done_testing;
