package Monad::Maybe;
use strict;
use warnings;
use utf8;
use feature 'state';
use Exporter 'import';
our @EXPORT_OK = qw/just nothing to_maybe/;
use Mouse;
with 'Monad';


has _value => (
    is  => 'ro'
);


#------ Functions ------#

sub just {
    my $value = shift;
    Monad::Maybe->new(_value => $value);
}

sub nothing () {
    state $nothing = Monad::Maybe->new;
    return $nothing;
}

sub to_maybe (&) {
    my $f = shift;
    my $result;
    eval { $result = $f->(); };

    $@ ? nothing : just($result);
}

#------ Methods ------#

sub unit {
    my ($class, $value) = @_;
    just($value);
}

sub is_nothing {
    my $self = shift;
    not exists $self->{_value};
}

sub map {
    my ($self, $f) = @_;
    return $self if $self->is_nothing;
    just($f->($self->{_value}));
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
