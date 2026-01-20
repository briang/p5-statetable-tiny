=head1 NAME

StateTable::Tiny - State tables for Perl using core modules only

=head1 VERSION

This is
version v0.0.1
released 2026-01-20

=cut

package StateTable::Tiny v0.1.0;

use 5.10.1;

use strict;
use warnings;

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

    $counter = StateTable::Tiny->new( XXX )

=cut

sub new {
    my ($class, %args) = @_;
    return bless {}, $class;
}

=head1 METHODS

=head2 method

    $stt->method()

XXX blah

=cut

sub method {
}

=head1 AUTHOR, COPYRIGHT AND LICENSE

Copyright 2026 Brian Greenfield <briang at cpan dot org>

This is free software. You can use, redistribute, and/or modify it
under the terms laid out in the L<MIT licence|LICENCE>.

=head1 SEE ALSO

L<CPAN::Meta::Spec>

L<ExtUtils::MakeMaker>

L<Release::Checklist>

L<Github Actions for Perl running on Windows, Mac OSX, and Ubuntu
Linux|https://perlmaven.com/github-actions-running-on-3-operating-systems>
by Gabor Szabo

TODO: others?

=head1 CODE REPOSITORY AND ISSUE REPORTING

This project's source code is
L<hosted|https://github.com/briang/p5-statetable-tiny> on
L<GitHub.com|http://github.com>.

Issues should be reported using the project's GitHub L<issue
tracker|https://github.com/briang/p5-statetable-tiny/issues>.

Contributions are welcome. Please use L<GitHub Pull
Requests|https://github.com/briang/p5-statetable-tiny/pulls>.

=head1 TODO: more pod???

=cut

1;
