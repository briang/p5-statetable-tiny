#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;

BEGIN {
    if ($ENV{INSIDE_EMACS}) {
        eval q(use FindBin '$Bin'; use lib "$Bin/../lib"; 1) or die 'I died';
    }
}

use Test::More;

use StateTable::Tiny;

my $stt = StateTable::Tiny->new();
ok $stt,     'new returned something';
ok ref $stt, 'new returned a reference';
is ref $stt, 'StateTable::Tiny', 'new returned an STT object';

done_testing;
