package Monad::Maybe;
use strict;
use warnings;
use utf8;
use feature 'state';
use Mouse;
with 'Monad';


has _value => (
    is  => 'ro'
);

#------ Functions ------#

sub unit {
    my ($class, $value) = @_;
    Monad::Maybe->just($value);
}

sub just {
    my ($class, $value) = @_;
    Monad::Maybe->new(_value => $value);
}

sub nothing () {
    state $nothing = Monad::Maybe->new;
    return $nothing;
}

sub is_nothing {
    my $self = shift;
    not exists $self->{_value};
}

sub map {
    my ($self, $f) = @_;
    return $self if $self->is_nothing;
    Monad::Maybe->just($f->($self->{_value}));
}

sub flatmap {
    my ($self, $f) = @_;
    my $mapped = $self->map($f);
    return $mapped if $mapped->is_nothing;
    $mapped->{_value};
}

sub value_or {
    my ($self, $value) = @_;
    return (ref $value eq 'CODE' ? $value->() : $value) if $self->is_nothing;
    $self->{_value};
}

1;
