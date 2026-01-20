#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;

use StateTable::Tiny;

my $C = StateTable::Tiny->new();
ok $C,     'new returned something';
ok ref $C, 'new returned a reference';
is ref $C, 'StateTable::Tiny', 'new returned an STT object';

done_testing;
