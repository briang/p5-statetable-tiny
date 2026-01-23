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

use Carp 'croak';
# use Data::Dump; # XXX

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

    my $stt = StateTable::Tiny->new()

XXX

=cut

our %FIELDS = (
    referenced_nodes => 'HASH',
    rules            => 'HASH',
);
our @FIELDS = keys %FIELDS;
for (@FIELDS) {
    eval qq[sub $_ { \$_[0]->{$_} }; 1] or die;
}

sub new {
    croak 'new() expected' unless @_ == 1;
    my ($class, %args) = @_;

    my %obj = map { $_ =>
                        ($FIELDS{$_} eq 'HASH')   ? {} :
                        ($FIELDS{$_} eq 'ARRAY')  ? [] :
                        ($FIELDS{$_} eq 'SCALAR') ? undef : die } @FIELDS;

    return bless \%obj, $class;
}

=head1 METHODS

=head2 add

    $stt->add(NODE, CONDITION, NEXT_NODE)

XXX

=cut

sub add {
    croak 'add(NODE, CONDITION, NEXT_NODE) expected' unless @_ == 4;
    my ($self, $node, $condition, $next_node) = @_;

    $condition = eval qq(sub { \$_[0] eq '$condition' });

    $self->rules->{$node} = [ $condition, $next_node ];
    $self->referenced_nodes->{$next_node} = ();
}

=head2 nodes

    my @nodes = $stt->nodes()

XXX

=cut

sub nodes {
    croak 'nodes() expected' unless @_ == 1;
    my ($self) = @_;

    my @rv = sort keys %{ $self->rules };
    return @rv;
}

=head2 referenced_nodes

    my $nodes_href = $stt->referenced_nodes()

XXX

=head2 rules

    my $rules_href = $stt->rules()

XXX

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
