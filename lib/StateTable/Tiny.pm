=head1 NAME

StateTable::Tiny - State tables for Perl using core modules only

=head1 VERSION

This is
version v0.0.1
released 2026-01-20

=cut

package StateTable::Tiny v0.1.0;

use v5.10;

use strict;
use warnings;

use Carp 'croak';
use constant {
    ACCEPT => 'ACCEPT',
    REJECT => 'REJECT',
    START  => 'START',
};
# use Data::Dump; # XXX

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

    my $stt = StateTable::Tiny->new()

XXX

=cut

our %FIELDS = (
    _current_state    => 'SCALAR',
    defined_states    => 'HASH',
    referenced_states => 'HASH',
    rules             => 'HASH', # HoA
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

    $stt->add(STATE, CONDITION, NEXT_STATE)

XXX

=cut

sub add {
    croak 'add(STATE, CONDITION, NEXT_STATE) expected' unless @_ == 4;
    my ($self, $state, $condition, $next_state) = @_;

    $condition = eval qq(sub { \$_[0] eq '$condition' });

    push @{ $self->rules->{$state} },  [ $condition, $next_state ];

    $self->defined_states->{$state} = undef;
    $self->referenced_states->{$next_state} = undef;
}

=head2 defined_states

    my $states_href = $stt->defined_states()

XXX

=head2 is_valid

    my $validity = $stt->is_valid()

XXX

=cut

sub is_valid { # XXX simplistic version needs more work
    croak 'is_valid() expected' unless @_ == 1;
    my ($self) = @_;

    my @dn = sort keys %{ $self->defined_states };
    my @rn = sort keys %{ $self->referenced_states };

    return @dn == @rn ? 1 : 0;
}

=head2 set_current_state

    $stt->set_current_state($STATE)

XXX

=cut

sub set_current_state {
    croak 'is_valid() expected' unless @_ == 2;
    my ($self, $value) = @_;

    $self->{_current_state} = $value;
}

=head2 states

    my @states = $stt->states()

XXX

=cut

sub states {
    croak 'states() expected' unless @_ == 1;
    my ($self) = @_;

    my @rv = sort keys %{ $self->rules };
    return @rv;
}

=head2 step

    $NEXT_STATE = $stt->step($INPUT)

XXX

=cut

sub step {
    croak 'states() expected' unless @_ == 2;
    my ($self, $input) = @_;

    my $current = $self->_current_state || START;

    if ($current eq ACCEPT or $current eq REJECT) {
        $self->set_current_state(undef);
        return undef;
    }

    for ( @{ $self->rules->{$current} } ) {
        my ($condition, $next_state) = @$_;
        if ($condition->($input)) {
            $self->set_current_state($next_state);
            return $next_state;
        }
    }
    croak 'croaked';
}

=head2 referenced_states

    my $states_href = $stt->referenced_states()

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
