#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;

use StateTable::Tiny;

my $stt = StateTable::Tiny->new();
ok $stt,     'new returned something';
ok ref $stt, 'new returned a reference';
is ref $stt, 'StateTable::Tiny', 'new returned an STT object';

done_testing;
