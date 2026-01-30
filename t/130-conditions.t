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

$stt->add($stt->START, 'string',            'STRING');
$stt->add($stt->START, qr/regex/,           'REGEX');
$stt->add($stt->START, sub { $_ eq 'sub' }, 'CODE');

my $state;

$stt->reset;
$state = $stt->step('string');
is $state, 'STRING', 'string match working';

$stt->reset;
$state = $stt->step('la la la regex la la');
is $state, 'REGEX', 'regex match working';

$stt->reset;
$state = $stt->step('sub');
is $state, 'CODE', 'subref match working';

done_testing;
