use strict;
use warnings;
use utf8;
use Test::More;

use Monad qw/do_monad/;
use Monad::Maybe qw/just nothing to_maybe/;

sub safety_divide {
    my ($x, $y) = @_;
    to_maybe { $x / $y };
}

subtest 'chain maybe' => sub {
    my $result = do_monad 'Monad::Maybe' => (
        x => sub { safety_divide(100, 10) },
        y => sub { safety_divide(100, 2) },
        sub { $_->{monad}->unit($_->{x} + $_->{y}) }
    );

    ok not $result->is_nothing;
    is $result->{_value}, 60;
};

subtest 'not chain maybe' => sub {
    my $z_called = 0;
    my $result = do_monad 'Monad::Maybe' => (
        x => sub { safety_divide(100, 20) },
        y => sub { safety_divide(200, 0) },
        z => sub { $z_called++; safety_divide(100, 40) },
        sub { $_->{monad}->unit($_->{x} + $_->{y}) }
    );

    ok $result->is_nothing;
    is $z_called, 0;
};

done_testing;
