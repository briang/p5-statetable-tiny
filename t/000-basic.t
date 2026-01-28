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
ok     $stt, 'new returned something';
ok ref $stt, 'new returned a reference';
is ref $stt, 'StateTable::Tiny', 'new returned an STT object';

my %fields = %StateTable::Tiny::FIELDS;
for my $method (sort keys %fields) { # keys returns random order
    my $type = $fields{$method};

    is ref $stt->can($method), 'CODE', qq[STT has a "$method" method];

    if ($type eq 'SCALAR') {
        ok ! defined $stt->$method, qq[$method() returns undef];
    }
    else {
        is ref $stt->$method, $type, qq[$method() returns a $type];
    }
}

done_testing;
