package Monad::Lazy;
use strict;
use warnings;
use utf8;
use Mouse;
with 'Monad';

# cache value
has _value => (
    is  => 'rw',
);

# value generator
has _gen => (
    is  => 'ro',
    isa => 'CodeRef',
    required => 1
);

#------ Functions ------#

sub unit {
    my ($class, $value) = @_;
    Monad::Lazy->new(_value => $value, _gen => sub { $value });
}

sub gen {
    my ($class, $f) = @_;
    Monad::Lazy->new(_gen => $f);
}

sub value {
    my $self = shift;
    $self->{_value} = $self->{_gen}->() if not defined $self->{_value};
    $self->{_value};
}

sub map {
    my ($self, $f) = @_;
    Monad::Lazy->new(_gen => sub { $f->($self->value) });
}

sub flatmap {
    my ($self, $f) = @_;
    Monad::Lazy->new(_gen => sub { $f->($self->value)->value });
}

1;
