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

use Data::Dump; # XXX

use StateTable::Tiny;

my $stt = StateTable::Tiny->new();
ok     $stt, 'new returned something';
ok ref $stt, 'new returned a reference';
is ref $stt, 'StateTable::Tiny', 'new returned an STT object';

for my $method (@StateTable::Tiny::FIELDS) {
    my $type = $StateTable::Tiny::FIELDS{$method};
    is ref $stt->can($method), 'CODE', qq[STT has a "$method" method];
    is ref $stt->$method, $type, qq[$method() returns a $type];
}

done_testing;
